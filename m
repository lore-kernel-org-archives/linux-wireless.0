Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36691 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbEQS4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 14:56:54 -0400
Received: by wgbhc8 with SMTP id hc8so131975814wgb.3
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2015 11:56:53 -0700 (PDT)
Message-ID: <5558E474.3070307@gmail.com> (sfid-20150517_205657_577596_20167228)
Date: Sun, 17 May 2015 20:56:52 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: Schmirr Wurst <schmirrwurst@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Fwd: Fwd: lspci not working
References: <CA+0W_As0c=eAijuvWfSBLMY4vj2P1-zoMsjz1mmNm0_vfepPCA@mail.gmail.com>	<5557556C.2080107@lwfinger.net>	<CACna6rwCapwThrMGt2HV_YyPQtZ+xRPJdBcapRqs2mkvGPdmSQ@mail.gmail.com>	<5557B396.9080300@gmail.com>	<CA+0W_At43pB=FeBR4jJzKxO3ruaATAidU8rimBOE3bLM1wKGsA@mail.gmail.com>	<CA+0W_AuXCgFoH2fm0kr5V9nkcNB9bCp8M4KF=J2=c5QCBrbL8A@mail.gmail.com>	<CA+0W_Asj3f10VJ=NVu_WGRO3iLyLZY3AhHnD3pkb7-r45j-yYA@mail.gmail.com>	<CA+0W_At6_zecdghFj1MS8XxiqvrELTd=TTPVZ84hEM=gqL-brw@mail.gmail.com>	<555894E7.3080600@hauke-m.de>	<CA+0W_AsY3sz9+t=guZYi9v-_X1-MMc5=11FPm=4QKkMxNd=uFQ@mail.gmail.com>	<CA+0W_Au9-xCi4mb1+1UTqQJ+ymHTqzbiORO6yiZD6CBAjZN1yQ@mail.gmail.com>	<5558A6F1.6010303@gmail.com>	<CA+0W_Au6N1cSELTBOQG2yPkiT5Pe9-sg3s_5YtNc9zFZ6T13sw@mail.gmail.com>	<CA+0W_AsDSA_Pg2f2HtgLkm2Nnn8C-FdxbrXe2F9p-d+y4ACbvg@mail.gmail.com>	<5558C6B2.7060105@gmail.com> <CA+0W_AvwkKg5Jfz2cKuLjs++7bLVWOsk64zNwE-J4PWz6yCGDg@mail.gmail.com>
In-Reply-To: <CA+0W_AvwkKg5Jfz2cKuLjs++7bLVWOsk64zNwE-J4PWz6yCGDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 17-05-15 19:56, Schmirr Wurst wrote:
> Well, has you noticed, I'm not really aware about firmware and the way
> linux deal with it, but you make magic happen, after 6 Months my
> friend will have wireless lan ! I want Broadcom to pay you ! and to

They already do, but I will tell my manager ;-)

> publish drivers and firmware for the community.. ;-)

If it is up to me we will.

> Many thanks

You are welcome.

Regards,
Arend

> 2015-05-17 18:49 GMT+02:00 Arend van Spriel <aspriel@gmail.com>:
>>
>>
>> On 17-05-15 16:48, Schmirr Wurst wrote:
>>>
>>> ---------- Forwarded message ----------
>>> From: Schmirr Wurst <schmirrwurst@gmail.com>
>>> Date: 2015-05-17 16:47 GMT+02:00
>>> Subject: Re: Fwd: lspci not working
>>> To: Arend van Spriel <aspriel@gmail.com>
>>>
>>>
>>> 2015-05-17 16:34 GMT+02:00 Arend van Spriel <aspriel@gmail.com>:
>>>>
>>>> On 17-05-15 16:08, Schmirr Wurst wrote:
>>>>>
>>>>>
>>>>> ---------- Forwarded message ----------
>>>>> From: Schmirr Wurst <schmirrwurst@gmail.com>
>>>>> Date: 2015-05-17 16:07 GMT+02:00
>>>>> Subject: Re: lspci not working
>>>>> To: Hauke Mehrtens <hauke@hauke-m.de>
>>>>>
>>>>>
>>>>> 2015-05-17 15:17 GMT+02:00 Hauke Mehrtens <hauke@hauke-m.de>:
>>>>>>
>>>>>>
>>>>>> On 05/17/2015 03:00 PM, Schmirr Wurst wrote:
>>>>>>>
>>>>>>>
>>>>>>> 2015-05-17 14:57 GMT+02:00 Schmirr Wurst <schmirrwurst@gmail.com>:
>>>>>>>>
>>>>>>>>
>>>>>>>> I'm not familiar with inline answers and mailing list, tried to put
>>>>>>>> some order in my answer + log file
>>>>>>>>
>>>>>>>> 2015-05-17 13:18 GMT+02:00 Rafał Miłecki <zajec5@gmail.com>:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 17 May 2015 at 12:23, Arend van Spriel <arend@broadcom.com>
>>>>>>>>> wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 05/17/15 02:21, Schmirr Wurst wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> I tried as suggested to had a look at
>>>>>>>>>>> /sys/bus/sdio/devices, but the only devices around there a 3
>>>>>>>>>>> mmc1:0001:1 to :3, I guess it is something else...
>>>>>>>>>>>
>>>>>>>>>>> I already try to install brcmfmac_sdio , with some tutorial from
>>>>>>>>>>> the
>>>>>>>>>>> internet, but it didn't work...
>>>>>>>>>>> actually, I see under /sys/bus/sdio/drivers brcmfmac_sdio ...
>>>>>>>>>>>
>>>>>>>>>>> In that directory, I see a directory mmc1:0001:2
>>>>>>>>>>> under device I have 0xa94d
>>>>>>>>>>>
>>>>>>>>>>> I completly lost, maybe you understand that information, sorry..
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> I do. The fact that you see a subdirectory mmc1:0001:2 in
>>>>>>>>>> /sys/bus/sdio/drivers/brcmfmac_sdio means that the driver was
>>>>>>>>>> probed
>>>>>>>>>> for
>>>>>>>>>> this device. Now would be a good time to share your (friends')
>>>>>>>>>> kernel
>>>>>>>>>> log,
>>>>>>>>>> but my guess is you are either missing firmware or nvram data or
>>>>>>>>>> both
>>>>>>>>>> for
>>>>>>>>>> this device.
>>>>>>>>
>>>>>>>>
>>>>>>>> I ve attatched the kernel.log here
>>>>>>>>
>>>>>>>> https://drive.google.com/file/d/0B8gm4mLCCQAgMmNlVVFSYmNjOGs/view?usp=sharing
>>>>>>>> In dmsg I see following linked with the brc driver :
>>>>>>>> dmesg | grep brc
>>>>>>>> [    7.987661] brcmf_sdio_drivestrengthinit: No SDIO Drive strength
>>>>>>>> init done for chip 43340 rev 2 pmurev 20
>>>>>>>> [    7.993487] usbcore: registered new interface driver brcmfmac
>>>>>>>> [    7.996318] brcmfmac_sdio mmc1:0001:1: Direct firmware load for
>>>>>>>> brcm/brcmfmac43340-sdio.bin failed with error -2
>>>>>>>> [    9.011572] brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl
>>>>>>>> 0x50
>>>>>>>> [   10.037365] brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl
>>>>>>>> 0x50
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> It could also mean driver was loaded manually. So please also make
>>>>>>>>> sure the friend uses kernel 4.0 or newer.
>>>>>>>>
>>>>>>>>
>>>>>>>> Kernel : 4.0.0 #3 SMP PREEMPT Wed Apr 22 17:52:53 MSK 2015
>>>>>>>> Distro:
>>>>>>>> Distributor ID:    T100 Ubuntu 15.04
>>>>>>>> Description:    Ubuntu 15.04
>>>>>>>> Release:    15.04
>>>>>>>> Codename:    vivid
>>>>>>>> I ve installed it from the magic stick here
>>>>>>>> https://plus.google.com/communities/117853703024346186936
>>>>>>
>>>>>>
>>>>>>
>>>>>> The driver complains about missing firmware and Ubuntu 15.04 does not
>>>>>> contain it.
>>>>>>
>>>>>> Please place this file
>>>>>>
>>>>>>
>>>>>> https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/plain/brcm/brcmfmac43340-sdio.bin
>>>>>>
>>>>>> to /lib/firmware/brcm/brcmfmac43340-sdio.bin
>>>>>>
>>>>>> Hauke
>>>>>
>>>>>
>>>>>     Before that, the system was complaining about
>>>>> brcm/brcmfmac43340-sdio.bin, and now about brcm/brcmfmac43340-sdio.txt
>>>>> but errors are similar...
>>>>
>>>>
>>>>
>>>> I guess your system in jinxed because of the hostname you setup :-p
>>>>
>>>> Ok, more seriously now. This is the nvram data I mentioned earlier. This
>>>> system may have that info stored in efi variable. You should be able to
>>>> find
>>>> it in /sys/firmware/efi/efivars/nvram-*.
>>>>
>>>> It may be necessary to run the following commands:
>>>>
>>>> # modprobe efivarfs
>>>> # mount -t efivarfs efivarfs /sys/firmware/efi/efivars
>>>>
>>>> Regards,
>>>> Arend
>>>>
>>> I cant be kind with manufacturer like broadcom and nvidia and those
>>> that are builting in such hardware ;)
>>
>>
>> You are talking to a broadcom employee (in disguise ;-) ).
>>
>>> cat /sys/firmware/efi/efivars/nvram-74b00bd9-805a-4d61-b51f-43268123d113
>>> What am I supposed to do with this ?
>>
>>
>> You are kidding? I'll chew it for you:
>>
>> $ cp /sys/firmware/efi/efivars/nvram-74b00bd9*
>> /lib/firmware/brcm/brcmfmac43340-sdio.txt
>>
>> Regards,
>> Arend
>>
>>> #T100TAF_AP6234ANS_NVRAM_V1.4.6_20140819_WIN8.1_WW.txt
>>> # 20140819 V1.4.6_WW
>>> # Update ccode to WW
>>> #
>>> # 20140815 V1.4.6_US
>>> # Update ccode to US
>>> #
>>> # 20140730 V1.4.6
>>> # Power offset adjustment
>>> #
>>> # 20140615 V1.4.4
>>> # Add interference and btc params and sd_gpdc=0 to fix CS issue
>>> #
>>> # 20140504 V1.4
>>> # Initial version
>>> manfid=0x2d0
>>> prodid=0x0653
>>> vendid=0x14e4
>>> devid=0x4386
>>> boardtype=0x0653
>>> boardrev=0x1203
>>> boardnum=22
>>> macaddr=00:90:4c:c5:12:38
>>> sromrev=3
>>> #boardflags:
>>> # bit 19 3tswitch:   2.4GHz FEM: SP3T switch share with BT
>>> # bit 16     nopa:   no external pa
>>> # keep original 0x200
>>> boardflags=0x0090201
>>> xtalfreq=37400
>>> nocrc=1
>>> ag0=255
>>> aa2g=1
>>> ccode=XV
>>> regrev=1
>>> pa0itssit=0x20
>>> #PA parameters for 2.4GHz
>>> pa0b0=7086
>>> pa0b1=-842
>>> pa0b2=-162
>>> tssifloor2g=63
>>> # rssi params for 2.4GHz
>>> rssismf2g=0xf
>>> rssismc2g=0x8
>>> rssisav2g=0x1
>>> cckPwrOffset=3
>>> # rssi params for 5GHz
>>> rssismf5g=0xf
>>> rssismc5g=0x7
>>> #rssisav5g=0x1
>>> rssisav5g=0x3
>>> #PA parameters for lower a-band
>>> pa1lob0=0x16D9
>>> pa1lob1=0xFD47
>>> pa1lob2=0xFF4E
>>> tssifloor5gl=32
>>> #PA parameters for midband
>>> pa1b0=0x15FF
>>> pa1b1=0xFD77
>>> pa1b2=0xFF75
>>> tssifloor5gm=34
>>> #PA paramasdeters for high band
>>> pa1hib0=0x158D
>>> pa1hib1=0xFD7D
>>> pa1hib2=0xFF6C
>>> tssifloor5gh=32
>>> rxpo5g=0
>>> maxp2ga0=80
>>> #  19.5dBm max; 18dBm target
>>> PwrOffset40mhz2g=8
>>> #HT40 2G OFFSET
>>> #Per rate power back-offs for g band, in .5 dB steps. Set it once you
>>> have the right numbers.
>>> cck2gpo=0xcccc
>>> ofdm2gpo=0xeeeedddd
>>> # R54 16dBm; R48 17dBm; others 18dBm
>>> mcs2gpo0=0xdddd
>>> # M0~ M4 17dBm
>>> mcs2gpo1=0xeccc
>>> # M5M6 15dBm; M7 14.5dBm
>>> #max power for 5G
>>> maxp5ga0=68
>>> # 16dBm target; 17.5dBm Max
>>> maxp5gla0=68
>>> maxp5gha0=68
>>> #Per rate power back-offs for a band, in .5 dB steps. Set it once you
>>> have the right numbers.
>>> PwrOffset40mhz5g=8
>>> #HT40 5G OFFSET
>>> ofdm5gpo=0x64447777
>>> # R54 13.5dBm
>>> ofdm5glpo=0x64447777
>>> ofdm5ghpo=0x75557777
>>> mcs5gpo0=0x6666
>>> # M0~M4 16dBm (1dB higher than ofdm)
>>> mcs5gpo1=0x6555
>>> # M5M6 13.5dBm; M7 12dBm
>>> mcs5glpo0=0x7776
>>> mcs5glpo1=0x6555
>>> mcs5ghpo0=0x7776
>>> mcs5ghpo1=0x6555
>>> # Parameters for DAC2x mode and ALPF bypass
>>> # RF SW Truth Table: ctrl0 for BT_TX; ctrl1 or 5G Tx; ctrl2 for 5G Rx;
>>> Ctrl3 for 2G Tx; Ctrl4 for 2G Rx
>>> swctrlmap_2g=0x00080008,0x00100010,0x00080008,0x011010,0x11f
>>> swctrlmap_5g=0x00040004,0x00020002,0x00040004,0x011010,0x2fe
>>> gain=32
>>> triso2g=8
>>> triso5g=8
>>> #tx parameters
>>> loflag=0
>>> iqlocalidx5g=40
>>> dlocalidx5g=70
>>> iqcalidx5g=50
>>> lpbckmode5g=1
>>> txiqlopapu5g=0
>>> txiqlopapu2g=0
>>> dlorange_lowlimit=5
>>> txalpfbyp=1
>>> txalpfpu=1
>>> dacrate2xen=1
>>> papden2g=1
>>> papden5g=1
>>> #rx parameters
>>> gain_settle_dly_2g=4
>>> gain_settle_dly_5g=4
>>> noise_cal_po_2g=-1
>>> noise_cal_po_40_2g=-1
>>> noise_cal_high_gain_2g=73
>>> noise_cal_nf_substract_val_2g=346
>>> noise_cal_po_5g=-1
>>> noise_cal_po_40_5g=-1
>>> noise_cal_high_gain_5g=73
>>> noise_cal_nf_substract_val_5g=346
>>> cckpapden=0
>>>
>>> sd_gpout=4
>>> sd_gpval=1
>>> sd_gpdc=0
>>> aci_detect_en_2g=1
>>> interference=3
>>> #BTC params
>>> btc_flags=71
>>> btc_params8=15000
>>> btc_params22=8000
>>> btc_params83=20000
>>> btc_params84=10000
>>>
>>>>
>>>>> 43340 rev 2 pmurev 20
>>>>> May 17 15:53:48 scheissasus kernel: [    7.372974] usbcore: registered
>>>>> new interface driver brcmfmac
>>>>> May 17 15:53:48 scheissasus kernel: [    7.374344] brcmfmac_sdio
>>>>> mmc1:0001:1: Direct firmware load for brcm/brcmfmac43340-sdio.bin
>>>>> failed with error -2
>>>>> May 17 15:53:48 scheissasus kernel: [    8.383270] brcmf_sdio_htclk:
>>>>> HT Avail timeout (1000000): clkctl 0x50
>>>>> May 17 15:53:50 scheissasus kernel: [   11.401582] brcmf_sdio_htclk:
>>>>> HT Avail timeout (1000000): clkctl 0x50
>>>>> May 17 15:59:23 scheissasus kernel: [    7.496560]
>>>>> brcmf_sdio_drivestrengthinit: No SDIO Drive strength init done for
>>>>> chip 43340 rev 2 pmurev 20
>>>>> May 17 15:59:23 scheissasus kernel: [    7.500086] usbcore: registered
>>>>> new interface driver brcmfmac
>>>>> May 17 15:59:23 scheissasus kernel: [    7.506911] brcmfmac_sdio
>>>>> mmc1:0001:1: Direct firmware load for brcm/brcmfmac43340-sdio.txt
>>>>> failed with error -2
>>>>> May 17 15:59:23 scheissasus kernel: [    8.514107] brcmf_sdio_htclk:
>>>>> HT Avail timeout (1000000): clkctl 0x50
>>>>> May 17 15:59:23 scheissasus kernel: [    9.531340] brcmf_sdio_htclk:
>>>>> HT Avail timeout (1000000): clkctl 0x50
>>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
