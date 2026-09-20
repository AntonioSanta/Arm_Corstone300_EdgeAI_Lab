#!/usr/bin/env python3
import urllib.request
import json
import numpy as np

def test_kw(kw, raw_peak_val=None):
    sr = 16000
    buf = np.zeros(sr, dtype=np.float32)
    for i in range(sr):
        t = i / sr
        if kw == 'yes':
            if 0.15 <= t < 0.75:
                prog = (t - 0.15) / 0.60
                env = np.sin(prog * np.pi)
                if prog < 0.3:
                    wave = np.sin(2 * np.pi * 320 * t) * 0.4
                elif prog < 0.65:
                    wave = np.sin(2 * np.pi * 520 * t) * 0.45 + np.sin(2 * np.pi * 1850 * t) * 0.35
                else:
                    wave = (np.random.rand() - 0.5) * 0.6 + np.sin(2 * np.pi * 4200 * t) * 0.25
                buf[i] = wave * env
            else:
                buf[i] = (np.random.rand() - 0.5) * 0.005
        elif kw == 'no':
            if 0.2 <= t < 0.7:
                prog = (t - 0.2) / 0.5
                env = np.sin(prog * np.pi)
                if prog < 0.35:
                    wave = np.sin(2 * np.pi * 260 * t) * 0.35
                else:
                    wave = np.sin(2 * np.pi * 480 * t) * 0.5 + np.sin(2 * np.pi * 880 * t) * 0.3
                buf[i] = wave * env
            else:
                buf[i] = (np.random.rand() - 0.5) * 0.005
        elif kw == 'silence' or kw == 'ambient_noise':
            # Ambient laptop fan / room hiss (flat, no speech burst)
            amp = 0.012 if kw == 'ambient_noise' else 0.002
            buf[i] = (np.random.rand() - 0.5) * (amp * 2)

    measured_peak = float(np.max(np.abs(buf)))
    pk = raw_peak_val if raw_peak_val is not None else measured_peak

    payload = json.dumps({'audio': buf.tolist(), 'mfcc': [-35]*490, 'raw_peak': pk}).encode('utf-8')
    req = urllib.request.Request('http://127.0.0.1:8080/predict', data=payload, headers={'Content-Type': 'application/json'})
    with urllib.request.urlopen(req, timeout=15) as resp:
        res = json.loads(resp.read().decode('utf-8'))
        print(f"Test {kw.upper():<14}: keyword='{res.get('keyword')}', class_idx={res.get('class_idx')}, conf={res.get('confidence')}%, fvp={res.get('fvp_available')}")

if __name__ == '__main__':
    test_kw('yes')
    test_kw('no')
    test_kw('silence')
    test_kw('ambient_noise', 0.015)
