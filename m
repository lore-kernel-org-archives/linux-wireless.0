Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42143 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2DTGnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 02:43:06 -0400
Received: by bkcik5 with SMTP id ik5so6926714bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 23:43:03 -0700 (PDT)
Subject: Re: wlan0 not present
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=iso-8859-1
From: Dominik Feser <dominik.feser@googlemail.com>
In-Reply-To: <CANUX_P1qCC63adSKHjHUcfufC0=QJLJz+Lqovk7ScHeE_hUuxg@mail.gmail.com>
Date: Fri, 20 Apr 2012 08:42:58 +0200
Cc: Dominik Feser <dominik.feser@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Message-Id: <146E772A-F387-4443-99C7-95C6B3BCE74C@gmail.com> (sfid-20120420_084325_137954_6230A2FF)
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com> <FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com> <CANUX_P0dR93vJicsrnpxPmOZvaxBvaONHQiFXOTcaP1Ax0LAnQ@mail.gmail.com> <816C5F70-E340-46F9-8206-2B230A27F3AD@gmail.com> <CANUX_P3=ttVKdLYBfAdGRhmfDRbPruogw8Eo_d09on0ajdTqUw@mail.gmail.com> <5714877C-2465-4FD5-94A0-9D0806A803C4@gmail.com> <CANUX_P27GoLY2q9jmsWw9Rzn9posf3mCjDa98+q4JP=83wYthg@mail.gmail.com> <8FBCAE90-FAE9-430D-888E-F055091E6683@gmail.com> <CANUX_P1OxH7rmYWxizEaf2DnPSTK0npNtZ2Q9Rm5dksnmFKD8g@mail.gmail.com> <9D52D4AD-58DC-4896-97FC-7248E1FD2614@gmail.com> <CANUX_P1ZX_e+0qs4sa7vdAqHvOQjO6+9PiFhDbW8ybE4ax80gQ@mail.gmail.com> <8EE08C44-8618-45EC-B890-B5B12B661FB6@gmail.com> <CANUX_P0O0-6sOaN59V_RxLj_DbiTdNdwq0zze6B6vMe1hfQuqA@mail.gmail.com> <37926591-261D-4C3E-A1D9-4A8AB3364F5D@gmail.com> <4F901224.1040508@sipsolutions.net> <EA757D90-2CCE-48A1-AF35-7F65EB45F7EE@gmail.com> <4F901F16.6080007@sipsolutions.net> <CAC79F14-24F2-4F90-8A47-B9B2744F5AE3@gmail.com> <CANUX_P2t86v0L=DDaaBdW-6Yb5ffSscv2aSy+jQ5dFc0TqWB_Q@mail.gmail.com> <D17CF50A-2CD7-427A-8159-A7857571823D@gmail.com> <CANUX_P1qCC63adSKHjHUcfufC0=QJLJz+Lqovk7ScHeE_hUuxg@mail.gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I downloaded the latest release from here: http://linuxwireless.org/en/users/Download/stable/ which is http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.4/compat-wireless-3.4-rc3-1.tar.bz2
Thx in advance, Emmanuel!


Am 19.04.2012 um 20:04 schrieb Emmanuel Grumbach:

> On Thu, Apr 19, 2012 at 20:26, Dominik Feser
> <dominik.feser@googlemail.com> wrote:
>> After applying the patch make comes up with:
>> 
>> # make
>> ./scripts/gen-compat-autoconf.sh /root/compat-wireless-3.4-rc1-2/.config /root/compat-wireless-3.4-rc1-2/config.mk > include/linux/compat_autoconf.h
>> make -C /lib/modules/2.6.32.12-0.7.1/build M=/root/compat-wireless-3.4-rc1-2 modules
>> make[1]: Entering directory `/mnt/src/redhat/BUILD/kernel-2.6.32.120.7.1'
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/main.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat-2.6.33.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat-2.6.35.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat-2.6.36.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/kfifo.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat-2.6.37.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat-2.6.38.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat-2.6.39.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/kstrtox.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat-3.0.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat-3.2.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat-3.3.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat-3.5.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/cordic.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/crc8.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat_atomic.o
>>  LD [M]  /root/compat-wireless-3.4-rc1-2/compat/compat.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/compat_firmware_class.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-agn.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-agn-rs.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-mac80211.o
>> /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-mac80211.c: In function »iwlagn_mac_resume«:
>> /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-mac80211.c:440: Warnung: Variable »img« wird nicht verwendet
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-ucode.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-agn-tx.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-debug.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-agn-lib.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-agn-calib.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-io.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-agn-tt.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-agn-sta.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-agn-rx.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-core.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-eeprom.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-power.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-scan.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-led.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-agn-rxon.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-5000.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-6000.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-1000.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-2000.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-pci.o
>>  CC [M]  /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-drv.o
>> /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-drv.c: In function »iwl_request_firmware«:
>> /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-drv.c:183: Fehler: »struct iwl_drv« hat kein Element namens »dev«
>> /root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-drv.c:183: Fehler: »struct iwl_drv« hat kein Element namens »dev«
>> make[4]: *** [/root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi/iwl-drv.o] Fehler 1
>> make[3]: *** [/root/compat-wireless-3.4-rc1-2/drivers/net/wireless/iwlwifi] Fehler 2
>> make[2]: *** [/root/compat-wireless-3.4-rc1-2/drivers/net/wireless] Fehler 2
>> make[1]: *** [_module_/root/compat-wireless-3.4-rc1-2] Fehler 2
>> make[1]: Leaving directory `/mnt/src/redhat/BUILD/kernel-2.6.32.120.7.1'
>> make: *** [modules] Fehler 2
>> 
>> the geman text means:
>> struct iwl_drv has no element with name dev
>> 
> 
> Yeah I know. I have some souvenirs from the years I was dreaming in my
> german classes.
> We did a lot of changes in our driver in the last months and our code
> bases is probably different.
> Can you please tell me where you took your compat from (sorry... I
> don't really know...) and I will make a patch based on your code.
> 
> I am not sure this will be before next week though...
> 
>> 
>> Am 19.04.2012 um 18:19 schrieb Emmanuel Grumbach:
>> 
>>> On Thu, Apr 19, 2012 at 18:08, Dominik Feser
>>> <dominik.feser@googlemail.com> wrote:
>>>> May it be that the fact that Centos 5 doesnt have hotplug causes the issue?
>>>> 
>>> 
>>> Don't think so.
>>> Can it be a problem in the backport of request_firwamre_no_wait ?
>>> Did I see somewhere that you run 2.6.38 ?
>>> Can you check again after having applied the patch attached ?
>>> 
>>> from the main dir of compat:
>>> patch -p1 < print.patch
>>> 
>>> Thanks
>>> 
>>>> Am 19.04.2012 um 16:20 schrieb Johannes Berg:
>>>> 
>>>>> On 4/19/2012 7:09 AM, Dominik Feser wrote:
>>>>>> Finally, here is the output of dmesg after recompiling:
>>>>>> 
>>>>>> iwlwifi 0000:02:00.0: edd19e18
>>>>>> iwlwifi 0000:02:00.0: d55c1e18
>>>>>> iwlwifi 0000:02:00.0: d55c1ddc
>>>>>> iwlwifi 0000:02:00.0: PCI INT A disabled
>>>>>> Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
>>>>>> Copyright(c) 2003-2012 Intel Corporation
>>>>>> iwlwifi 0000:02:00.0: PCI INT A ->  GSI 17 (level, low) ->  IRQ 17
>>>>>> iwlwifi 0000:02:00.0: setting latency timer to 64
>>>>>> iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
>>>>>> iwlwifi 0000:02:00.0: pci_resource_base = f447c000
>>>>>> iwlwifi 0000:02:00.0: HW Revision ID = 0x34
>>>>>> iwlwifi 0000:02:00.0: irq 1277 (277) for MSI/MSI-X
>>>>>> iwlwifi 0000:02:00.0: U iwl_request_firmware d5b37d70
>>>>>> iwlwifi 0000:02:00.0: U iwl_request_firmware e09ebdd4
>>>>>> iwlwifi 0000:02:00.0: ee2afe18
>>>>>> iwlwifi 0000:02:00.0: U iwl_request_firmware ee2afdd4
>>>>>> iwlwifi 0000:02:00.0: cc93fe18
>>>>>> iwlwifi 0000:02:00.0: cc93fddc
>>>>> 
>>>>> Still pretty useless since you get %pV printed as a pointer rather than a message. Does anyone know how to fix that in compat? But the iwl_request_firmware 3 times probably means it failed?
>>>>> 
>>>>> johannes
>>>> 
>>> <print.patch>
>> 

