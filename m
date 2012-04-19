Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43510 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2DSNQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 09:16:57 -0400
Received: by wgbdr13 with SMTP id dr13so8618342wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 06:16:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8EE08C44-8618-45EC-B890-B5B12B661FB6@gmail.com>
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
	<4F8DC25E.9090702@broadcom.com>
	<B9AA983D-A169-497D-9C8E-BDBEF2348BB6@gmail.com>
	<4F8E0CBE.6010103@sipsolutions.net>
	<0FC1AE2B-7E32-466B-AC33-F969F4E72B98@gmail.com>
	<CANUX_P38YDFtL-KzKnFHd0+Ca29SUXoY+mGKaDUjConXaf3c9A@mail.gmail.com>
	<4B048FDE-C784-4401-9FEC-16F8CC0B8D59@gmail.com>
	<CANUX_P0FO-P6ZFow15shNpZg6Z8FAPP7AovJH=xUKPyVEMtoBw@mail.gmail.com>
	<FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com>
	<CANUX_P0dR93vJicsrnpxPmOZvaxBvaONHQiFXOTcaP1Ax0LAnQ@mail.gmail.com>
	<816C5F70-E340-46F9-8206-2B230A27F3AD@gmail.com>
	<CANUX_P3=ttVKdLYBfAdGRhmfDRbPruogw8Eo_d09on0ajdTqUw@mail.gmail.com>
	<5714877C-2465-4FD5-94A0-9D0806A803C4@gmail.com>
	<CANUX_P27GoLY2q9jmsWw9Rzn9posf3mCjDa98+q4JP=83wYthg@mail.gmail.com>
	<8FBCAE90-FAE9-430D-888E-F055091E6683@gmail.com>
	<CANUX_P1OxH7rmYWxizEaf2DnPSTK0npNtZ2Q9Rm5dksnmFKD8g@mail.gmail.com>
	<9D52D4AD-58DC-4896-97FC-7248E1FD2614@gmail.com>
	<CANUX_P1ZX_e+0qs4sa7vdAqHvOQjO6+9PiFhDbW8ybE4ax80gQ@mail.gmail.com>
	<8EE08C44-8618-45EC-B890-B5B12B661FB6@gmail.com>
Date: Thu, 19 Apr 2012 16:16:56 +0300
Message-ID: <CANUX_P0O0-6sOaN59V_RxLj_DbiTdNdwq0zze6B6vMe1hfQuqA@mail.gmail.com> (sfid-20120419_151702_325263_87A6AFF0)
Subject: Re: wlan0 not present
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dominik Feser <dominik.feser@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 19, 2012 at 13:08, Dominik Feser
<dominik.feser@googlemail.com> wrote:
> Sice I downloaded compat-wireless manually and without git the command you proposed doesn't work. I would use git but I couldn't find a url to clone from.
> Can you give a hint on that?
>

Just unpack the tar again.

>
> Am 19.04.2012 um 09:54 schrieb Emmanuel Grumbach:
>
>> On Thu, Apr 19, 2012 at 10:49, Dominik Feser
>> <dominik.feser@googlemail.com> wrote:
>>> Here is the output! And by the way, I really appreciate your help! Thank you!
>>>
>>> # modinfo iwlwifi
>>> filename:       /lib/modules/2.6.32.12-0.7.1/updates/drivers/net/wireless/iwlwifi/iwlwifi.ko
>>> alias:          iwlagn
>>> license:        GPL
>>> author:         Copyright(c) 2003-2012 Intel Corporation <ilw@linux.intel.com>
>>> version:        in-tree:
>>> description:    Intel(R) Wireless WiFi Link AGN driver for Linux
>>> firmware:       iwlwifi-5150-2.ucode
>>> firmware:       iwlwifi-5000-5.ucode
>>> firmware:       iwlwifi-6000g2b-6.ucode
>>> firmware:       iwlwifi-6000g2a-6.ucode
>>> firmware:       iwlwifi-6050-5.ucode
>>> firmware:       iwlwifi-6000-4.ucode
>>> firmware:       iwlwifi-100-6.ucode
>>> firmware:       iwlwifi-1000-6.ucode
>>> firmware:       iwlwifi-135-6.ucode
>>> firmware:       iwlwifi-105-6.ucode
>>> firmware:       iwlwifi-2030-6.ucode
>>> firmware:       iwlwifi-2000-6.ucode
>>> srcversion:     169044416CC2B674049889B
>>> alias:          pci:v00008086d00000892sv*sd00000462bc*sc*i*
>>> alias:          pci:v00008086d00000893sv*sd00000262bc*sc*i*
>>> alias:          pci:v00008086d00000892sv*sd00000062bc*sc*i*
>>> alias:          pci:v00008086d00000894sv*sd00000822bc*sc*i*
>>> alias:          pci:v00008086d00000894sv*sd00000422bc*sc*i*
>>> alias:          pci:v00008086d00000895sv*sd00000222bc*sc*i*
>>> alias:          pci:v00008086d00000894sv*sd00000022bc*sc*i*
>>> alias:          pci:v00008086d0000088Esv*sd00004860bc*sc*i*
>>> alias:          pci:v00008086d0000088Esv*sd00004460bc*sc*i*
>>> alias:          pci:v00008086d0000088Fsv*sd00004260bc*sc*i*
>>> alias:          pci:v00008086d0000088Esv*sd00004060bc*sc*i*
>>> alias:          pci:v00008086d00000887sv*sd00004462bc*sc*i*
>>> alias:          pci:v00008086d00000888sv*sd00004262bc*sc*i*
>>> alias:          pci:v00008086d00000887sv*sd00004062bc*sc*i*
>>> alias:          pci:v00008086d00000890sv*sd00004822bc*sc*i*
>>> alias:          pci:v00008086d00000890sv*sd00004422bc*sc*i*
>>> alias:          pci:v00008086d00000891sv*sd00004222bc*sc*i*
>>> alias:          pci:v00008086d00000890sv*sd00004022bc*sc*i*
>>> alias:          pci:v00008086d00000896sv*sd00005027bc*sc*i*
>>> alias:          pci:v00008086d00000896sv*sd00005025bc*sc*i*
>>> alias:          pci:v00008086d00000897sv*sd00005017bc*sc*i*
>>> alias:          pci:v00008086d00000897sv*sd00005015bc*sc*i*
>>> alias:          pci:v00008086d00000896sv*sd00005007bc*sc*i*
>>> alias:          pci:v00008086d00000896sv*sd00005005bc*sc*i*
>>> alias:          pci:v00008086d000008AEsv*sd00001027bc*sc*i*
>>> alias:          pci:v00008086d000008AEsv*sd00001025bc*sc*i*
>>> alias:          pci:v00008086d000008AFsv*sd00001017bc*sc*i*
>>> alias:          pci:v00008086d000008AFsv*sd00001015bc*sc*i*
>>> alias:          pci:v00008086d000008AEsv*sd00001007bc*sc*i*
>>> alias:          pci:v00008086d000008AEsv*sd00001005bc*sc*i*
>>> alias:          pci:v00008086d00000084sv*sd00001316bc*sc*i*
>>> alias:          pci:v00008086d00000084sv*sd00001216bc*sc*i*
>>> alias:          pci:v00008086d00000083sv*sd00001326bc*sc*i*
>>> alias:          pci:v00008086d00000083sv*sd00001226bc*sc*i*
>>> alias:          pci:v00008086d00000083sv*sd00001306bc*sc*i*
>>> alias:          pci:v00008086d00000083sv*sd00001206bc*sc*i*
>>> alias:          pci:v00008086d00000084sv*sd00001315bc*sc*i*
>>> alias:          pci:v00008086d00000084sv*sd00001215bc*sc*i*
>>> alias:          pci:v00008086d00000083sv*sd00001325bc*sc*i*
>>> alias:          pci:v00008086d00000083sv*sd00001225bc*sc*i*
>>> alias:          pci:v00008086d00000083sv*sd00001305bc*sc*i*
>>> alias:          pci:v00008086d00000083sv*sd00001205bc*sc*i*
>>> alias:          pci:v00008086d00000886sv*sd00001317bc*sc*i*
>>> alias:          pci:v00008086d00000886sv*sd00001315bc*sc*i*
>>> alias:          pci:v00008086d00000885sv*sd00001327bc*sc*i*
>>> alias:          pci:v00008086d00000885sv*sd00001325bc*sc*i*
>>> alias:          pci:v00008086d00000885sv*sd00001307bc*sc*i*
>>> alias:          pci:v00008086d00000885sv*sd00001305bc*sc*i*
>>> alias:          pci:v00008086d00000089sv*sd00001316bc*sc*i*
>>> alias:          pci:v00008086d00000089sv*sd00001311bc*sc*i*
>>> alias:          pci:v00008086d00000087sv*sd00001326bc*sc*i*
>>> alias:          pci:v00008086d00000087sv*sd00001321bc*sc*i*
>>> alias:          pci:v00008086d00000087sv*sd00001306bc*sc*i*
>>> alias:          pci:v00008086d00000087sv*sd00001301bc*sc*i*
>>> alias:          pci:v00008086d00000091sv*sd00005226bc*sc*i*
>>> alias:          pci:v00008086d00000091sv*sd00005225bc*sc*i*
>>> alias:          pci:v00008086d00000091sv*sd00005221bc*sc*i*
>>> alias:          pci:v00008086d00000091sv*sd00005207bc*sc*i*
>>> alias:          pci:v00008086d00000091sv*sd00005206bc*sc*i*
>>> alias:          pci:v00008086d00000091sv*sd00005205bc*sc*i*
>>> alias:          pci:v00008086d00000091sv*sd00005201bc*sc*i*
>>> alias:          pci:v00008086d00000090sv*sd00005216bc*sc*i*
>>> alias:          pci:v00008086d00000090sv*sd00005215bc*sc*i*
>>> alias:          pci:v00008086d00000090sv*sd00005211bc*sc*i*
>>> alias:          pci:v00008086d0000008Bsv*sd00005317bc*sc*i*
>>> alias:          pci:v00008086d0000008Bsv*sd00005315bc*sc*i*
>>> alias:          pci:v00008086d0000008Asv*sd00005327bc*sc*i*
>>> alias:          pci:v00008086d0000008Asv*sd00005325bc*sc*i*
>>> alias:          pci:v00008086d0000008Asv*sd00005307bc*sc*i*
>>> alias:          pci:v00008086d0000008Asv*sd00005305bc*sc*i*
>>> alias:          pci:v00008086d00000082sv*sd00001305bc*sc*i*
>>> alias:          pci:v00008086d00000082sv*sd00001304bc*sc*i*
>>> alias:          pci:v00008086d00000082sv*sd00004820bc*sc*i*
>>> alias:          pci:v00008086d00000085sv*sd0000C220bc*sc*i*
>>> alias:          pci:v00008086d00000082sv*sd0000C020bc*sc*i*
>>> alias:          pci:v00008086d00000085sv*sd00001316bc*sc*i*
>>> alias:          pci:v00008086d00000085sv*sd00001311bc*sc*i*
>>> alias:          pci:v00008086d00000082sv*sd00001326bc*sc*i*
>>> alias:          pci:v00008086d00000082sv*sd00001321bc*sc*i*
>>> alias:          pci:v00008086d00000082sv*sd00001307bc*sc*i*
>>> alias:          pci:v00008086d00000082sv*sd00001306bc*sc*i*
>>> alias:          pci:v00008086d00000082sv*sd00001301bc*sc*i*
>>> alias:          pci:v00008086d00004239sv*sd00001316bc*sc*i*
>>> alias:          pci:v00008086d00004239sv*sd00001311bc*sc*i*
>>> alias:          pci:v00008086d00004238sv*sd00001111bc*sc*i*
>>> alias:          pci:v00008086d0000422Csv*sd00001326bc*sc*i*
>>> alias:          pci:v00008086d0000422Csv*sd00001321bc*sc*i*
>>> alias:          pci:v00008086d0000422Csv*sd00001307bc*sc*i*
>>> alias:          pci:v00008086d0000422Csv*sd00001306bc*sc*i*
>>> alias:          pci:v00008086d0000422Csv*sd00001301bc*sc*i*
>>> alias:          pci:v00008086d0000422Bsv*sd00001121bc*sc*i*
>>> alias:          pci:v00008086d0000422Bsv*sd00001101bc*sc*i*
>>> alias:          pci:v00008086d0000423Dsv*sd00001316bc*sc*i*
>>> alias:          pci:v00008086d0000423Dsv*sd00001216bc*sc*i*
>>> alias:          pci:v00008086d0000423Dsv*sd00001311bc*sc*i*
>>> alias:          pci:v00008086d0000423Dsv*sd00001211bc*sc*i*
>>> alias:          pci:v00008086d0000423Csv*sd00001321bc*sc*i*
>>> alias:          pci:v00008086d0000423Csv*sd00001221bc*sc*i*
>>> alias:          pci:v00008086d0000423Csv*sd00001306bc*sc*i*
>>> alias:          pci:v00008086d0000423Csv*sd00001206bc*sc*i*
>>> alias:          pci:v00008086d0000423Csv*sd00001301bc*sc*i*
>>> alias:          pci:v00008086d0000423Csv*sd00001201bc*sc*i*
>>> alias:          pci:v00008086d0000423Bsv*sd00001011bc*sc*i*
>>> alias:          pci:v00008086d0000423Asv*sd00001021bc*sc*i*
>>> alias:          pci:v00008086d0000423Asv*sd00001001bc*sc*i*
>>> alias:          pci:v00008086d00004236sv*sd00001114bc*sc*i*
>>> alias:          pci:v00008086d00004236sv*sd00001014bc*sc*i*
>>> alias:          pci:v00008086d00004236sv*sd00001111bc*sc*i*
>>> alias:          pci:v00008086d00004236sv*sd00001011bc*sc*i*
>>> alias:          pci:v00008086d00004235sv*sd00001104bc*sc*i*
>>> alias:          pci:v00008086d00004235sv*sd00001004bc*sc*i*
>>> alias:          pci:v00008086d00004235sv*sd00001101bc*sc*i*
>>> alias:          pci:v00008086d00004235sv*sd00001001bc*sc*i*
>>> alias:          pci:v00008086d00004235sv*sd00001124bc*sc*i*
>>> alias:          pci:v00008086d00004235sv*sd00001024bc*sc*i*
>>> alias:          pci:v00008086d00004235sv*sd00001121bc*sc*i*
>>> alias:          pci:v00008086d00004235sv*sd00001021bc*sc*i*
>>> alias:          pci:v00008086d00004237sv*sd00001316bc*sc*i*
>>> alias:          pci:v00008086d00004237sv*sd00001216bc*sc*i*
>>> alias:          pci:v00008086d00004237sv*sd00001315bc*sc*i*
>>> alias:          pci:v00008086d00004237sv*sd00001215bc*sc*i*
>>> alias:          pci:v00008086d00004237sv*sd00001314bc*sc*i*
>>> alias:          pci:v00008086d00004237sv*sd00001214bc*sc*i*
>>> alias:          pci:v00008086d00004237sv*sd00001311bc*sc*i*
>>> alias:          pci:v00008086d00004237sv*sd00001211bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001326bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001226bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001325bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001225bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001324bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001224bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001321bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001221bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001306bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001206bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001305bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001205bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001304bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001204bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001301bc*sc*i*
>>> alias:          pci:v00008086d00004232sv*sd00001201bc*sc*i*
>>> depends:        mac80211,compat,led-class,cfg80211,compat_firmware_class
>>> vermagic:       2.6.32.12-0.7.1 SMP mod_unload modversions Xen 686
>>> parm:           swcrypto:using crypto in software (default 0 [hardware]) (int)
>>> parm:           11n_disable:disable 11n functionality, bitmap: 1: full, 2: agg TX, 4: agg RX (uint)
>>> parm:           amsdu_size_8K:enable 8K amsdu size (int)
>>> parm:           fw_restart:restart firmware in case of error (int)
>>> parm:           ucode_alternative:specify ucode alternative to use from ucode file (int)
>>> parm:           antenna_coupling:specify antenna coupling in dB (defualt: 0 dB) (int)
>>> parm:           bt_ch_inhibition:Enable BT channel inhibition (default: enable) (bool)
>>> parm:           plcp_check:Check plcp health (default: 1 [enabled]) (bool)
>>> parm:           ack_check:Check ack health (default: 0 [disabled]) (bool)
>>> parm:           wd_disable:Disable stuck queue watchdog timer 0=system default, 1=disable, 2=enable (default: 0) (int)
>>> parm:           bt_coex_active:enable wifi/bt co-exist (default: enable) (bool)
>>> parm:           led_mode:0=system default, 1=On(RF On)/Off(RF Off), 2=blinking, 3=Off (default: 0) (int)
>>> parm:           power_save:enable WiFi power management (default: disable) (bool)
>>> parm:           power_level:default power save level (range from 1 - 5, default: 1) (int)
>>> parm:           auto_agg:enable agg w/o check traffic load (default: enable) (bool)
>>> parm:           no_sleep_autoadjust:don't automatically adjust sleep level according to maximum network latency (default: true) (bool)
>>>
>>
>> All right, no debug in there.
>> I understand that you use compat.
>> Please clean everything:
>>
>> git clean -f -d -x
>>
>> Beware this will remove all the files that you have added there. This
>> won't remove the W/A you made to compile.
>
