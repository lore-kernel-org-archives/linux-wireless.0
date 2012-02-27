Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52813 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2B0R2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 12:28:21 -0500
Received: by wejx9 with SMTP id x9so429876wej.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 09:28:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F4BB163.20107@lwfinger.net>
References: <loom.20120227T170610-925@post.gmane.org>
	<4F4BB163.20107@lwfinger.net>
Date: Mon, 27 Feb 2012 18:28:19 +0100
Message-ID: <CACna6rx0MkfZhmKnb0A=PwM-x82AoN1Lb5rNt2oD3rZAgk5YDQ@mail.gmail.com> (sfid-20120227_182824_494918_2C904E18)
Subject: Re: Problems with Realtek USB rtl8192cu
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chris Thompson <bradhex@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/2/27 Larry Finger <Larry.Finger@lwfinger.net>:
> On 02/27/2012 10:09 AM, Chris Thompson wrote:
>>
>> Hello,
>>
>> I'm attempting to get my belkin n300 to work with the kernel driver
>> rtl8192cu. I
>> was previously using the realtek drivers but this only resulted in slow
>> speeds.
>>
>> I am running kernel 3.2.7 with the following information:
>>
>> Bus 001 Device 004: ID 050d:2103 Belkin Components
>> Device Descriptor:
>>   bLength                18
>>   bDescriptorType         1
>>   bcdUSB               2.00
>>   bDeviceClass            0 (Defined at Interface level)
>>   bDeviceSubClass         0
>>   bDeviceProtocol         0
>>   bMaxPacketSize0        64
>>   idVendor           0x050d Belkin Components
>>   idProduct          0x2103
>>   bcdDevice            2.00
>>   iManufacturer           1 Realtek
>>   iProduct                2 Belkin Wireless Adapter
>>   iSerial                 3 00e04c000001
>>
>> modinfo rtl8192cu returns this:
>> filename:
>>
>> /lib/modules/3.2.7/kernel/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
>> firmware:       rtlwifi/rtl8192cufw.bin
>> description:    Realtek 8192C/8188C 802.11n USB wireless
>> license:        GPL
>> author:         Larry Finger<Larry.Finger@lwfinger.net>
>> author:         Ziv Huang<ziv_huang@realtek.com>
>> author:         Georgia<georgia@realtek.com>
>>
>> alias:          usb:v7392p7822d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v2019pAB2Bd*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v2001p330Ad*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v2001p3309d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v2001p3307d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v07B8p8178d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v07AAp0056d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0586p341Fd*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v9846p9041d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v4855p0091d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v4855p0090d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v13D3p3359d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v13D3p3358d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v7392p7811d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v20F4p648Bd*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v2019pED17d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v2019pAB2Ad*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v2001p3308d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v13D3p3357d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v103Cp1629d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0EB0p9071d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0DF6p0052d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0846p9041d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v07B8p8189d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v07B8p8188d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v06F8pE033d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v050Dp1102d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp817Cd*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp817Bd*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp8177d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp8754d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp817Fd*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp817Ed*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp817Dd*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp817Bd*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp817Ad*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp8177d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp8176d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp8170d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0BDAp8191d*dc*dsc*dp*ic*isc*ip*
>> depends:        rtlwifi,mac80211,rtl8192c-common
>> intree:         Y
>> vermagic:       3.2.7 SMP preempt mod_unload 586
>> parm:           swenc:Set to 1 for software crypto (default 0)
>>  (bool)
>> parm:           debug:Set debug level (0-5) (default 0) (int)
>>
>>
>> ls -l /lib/firmware/rtlwifi:
>> total 16
>> -rwxr-xr-x 1 root root 16014 Feb 22 15:54 rtl8192cufw.bin
>>
>> I have also ran md5checksum on the firmware file, it came back fine.
>>
>> When I run modprobe rtl8192cu, this is what dmesg reports:
>>
>> [ 1378.073848] usbcore: registered new interface driver rtl8192cu
>>
>> Nothing else. This is what lsmod returns:
>>
>> Module                  Size  Used by
>> rtl8192cu              86266  0
>> rtl8192c_common        53218  1 rtl8192cu
>> rtlwifi                81918  1 rtl8192cu
>> mac80211              165677  3 rtl8192cu,rtl8192c_common,rtlwifi
>> cfg80211              141272  2 rtlwifi,mac80211
>>
>>
>>
>> What should I try next to get this module working? I hope I have given
>> enough
>> information on trying to troubleshoot this.
>
>
> Your device is in the current tables with the insertion patch date October
> 2011. Unfortunately, I failed to Cc it to Stable, thus the patch was not
> backported to 3.2.7.
>
> You could either choose to get a recent version of compat-wireless, or you
> can
>
> echo "050d 2103" > /sys/bus/usb/drivers/rtl8192cu/new_id
>
> (as root). That should bring the device to life.

Is that only about device table? You can always ask Greg to cherry-pick :)

-- 
Rafał
