Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:47000 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752045AbeB0JFp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 04:05:45 -0500
Subject: Re: [PULL] ath10k firmware 20180219
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
References: <87y3jlxq0k.fsf@kamboji.qca.qualcomm.com>
 <0e9db63d-41e9-eeb3-00d1-73b20df4bb3f@dd-wrt.com>
 <87606ju7ae.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <150ef362-418d-e571-a95d-b1fa7d6db14c@dd-wrt.com> (sfid-20180227_100735_867625_4DEDD523)
Date: Tue, 27 Feb 2018 10:05:38 +0100
MIME-Version: 1.0
In-Reply-To: <87606ju7ae.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

what about this?


[   90.164755] ath10k_pci 0001:03:00.0: firmware crashed! (uuid n/a)
[   90.170845] ath10k_pci 0001:03:00.0: qca9984/qca9994 hw1.0 target 
0x01000000 chip_id 0x00000000 sub 168c:cafe
[   90.180747] ath10k_pci 0001:03:00.0: kconfig debug 1 debugfs 1 
tracing 0 dfs 0 testmode 0
[   90.189767] ath10k_pci 0001:03:00.0: firmware ver 10.4-3.5.3-00053 
api 5 features 
no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps crc32 
4c56a386
[   90.204013] ath10k_pci 0001:03:00.0: board_file api 1 bmi_id N/A 
crc32 31ab2fd1
[   90.211307] ath10k_pci 0001:03:00.0: htt-ver 2.2 wmi-op 6 htt-op 4 
cal otp max-sta 512 raw 0 hwcrypto 1
[   90.222712] ath10k_pci 0001:03:00.0: firmware register dump:
[   90.228360] ath10k_pci 0001:03:00.0: [00]: 0x0000000A 0x000015B3 
0x0A0014F9 0x00975B31
[   90.236266] ath10k_pci 0001:03:00.0: [04]: 0x0A0014F9 0x00060730 
0x0000001D 0x0000000A
[   90.244171] ath10k_pci 0001:03:00.0: [08]: 0x0042F23C 0x0045E8E0 
0x000EEE00 0x00000001
[   90.252075] ath10k_pci 0001:03:00.0: [12]: 0x00000009 0x00000000 
0x00973ABC 0x00973AD2
[   90.259974] ath10k_pci 0001:03:00.0: [16]: 0x0A0014F9 0x009C36CB 
0x009606CA 0x00000000
[   90.267879] ath10k_pci 0001:03:00.0: [20]: 0x409CB97D 0x0040673C 
0x00400000 0x0000000E
[   90.275784] ath10k_pci 0001:03:00.0: [24]: 0x809805BF 0x0040679C 
0x00000000 0xC09CB97D
[   90.283688] ath10k_pci 0001:03:00.0: [28]: 0x809C9B59 0x004068BC 
0x00000000 0x00009026
[   90.291586] ath10k_pci 0001:03:00.0: [32]: 0x809B72AF 0x004068EC 
0x000EEE00 0x0042C264
[   90.299491] ath10k_pci 0001:03:00.0: [36]: 0x809B39F2 0x0040692C 
0x00000002 0x0042C264
[   90.307396] ath10k_pci 0001:03:00.0: [40]: 0x809B30CF 0x0040695C 
0x00406980 0x0042443C
[   90.315300] ath10k_pci 0001:03:00.0: [44]: 0x8096EE0E 0x0040697C 
0x000EEDF4 0x00000001
[   90.323204] ath10k_pci 0001:03:00.0: [48]: 0x8096F883 0x00406A2C 
0x0042DE2C 0x00424A64
[   90.331102] ath10k_pci 0001:03:00.0: [52]: 0x80963A26 0x00406A4C 
0x0042DE2C 0x00405528
[   90.339006] ath10k_pci 0001:03:00.0: [56]: 0x80960E80 0x00406A9C 
0x0000000D 0x00400000
[   90.346910] ath10k_pci 0001:03:00.0: Copy Engine register dump:
[   90.352829] ath10k_pci 0001:03:00.0: [00]: 0x0004a000  15  15 3   3
[   90.359262] ath10k_pci 0001:03:00.0: [01]: 0x0004a400   7   7 74  75
[   90.365700] ath10k_pci 0001:03:00.0: [02]: 0x0004a800  47  47 46  47
[   90.372139] ath10k_pci 0001:03:00.0: [03]: 0x0004ac00  31  31 0  31
[   90.378571] ath10k_pci 0001:03:00.0: [04]: 0x0004b000  11  11 51  11
[   90.385008] ath10k_pci 0001:03:00.0: [05]: 0x0004b400   8   8 71  72
[   90.391440] ath10k_pci 0001:03:00.0: [06]: 0x0004b800   3   3 3   3
[   90.397879] ath10k_pci 0001:03:00.0: [07]: 0x0004bc00   1   1 1   1
[   90.404318] ath10k_pci 0001:03:00.0: [08]: 0x0004c000   0   0 127   0
[   90.410748] ath10k_pci 0001:03:00.0: [09]: 0x0004c400   0   0 0   0
[   90.417185] ath10k_pci 0001:03:00.0: [10]: 0x0004c800   0   0 0   0
[   90.423623] ath10k_pci 0001:03:00.0: [11]: 0x0004cc00   0   0 0   0
[   90.430142] ath10k_pci 0001:03:00.0: failed to setup peer SMPS for 
vdev 0: -108
[   90.437452] ath10k_pci 0001:03:00.0: failed to associate station 
14:91:82:b9:16:d4 for vdev 0: -108
[   90.532746] ieee80211 phy0: Hardware restart was requested
[   90.538253] ath10k_pci 0001:03:00.0: failed to delete peer 
14:91:82:b9:16:d4 for vdev 0: -108
[   94.931518] ath10k_pci 0001:03:00.0: device successfully recovered


Am 26.02.2018 um 15:58 schrieb Kalle Valo:
> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>
>> on 9984 i see these messages with this firmware from time to time
>>
>> [272972.950788] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
>> [272982.868922] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
>> [335550.123780] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
>> [335550.156332] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
>> [335550.158813] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
>> [335550.193144] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
>> [365157.869540] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
>> [365157.902452] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
>>
>>
>> according to the WMI header this maybe a critical internal error
> Thanks for the report. We are working on a fix but just ignore the
> warning for now.
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
