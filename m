Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:55523 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755572AbYB0Ffy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 00:35:54 -0500
Message-ID: <47C4F4B4.7030300@gmail.com> (sfid-20080227_053626_538241_5E241915)
Date: Tue, 26 Feb 2008 22:27:16 -0700
From: Larry Finger <Larry.Finger@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Wu <flamingice@sourmilk.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problems with RTL8187 USB device
References: <47C49D21.1030905@lwfinger.net> <20080227010732.GB3066@tuxdriver.com>
In-Reply-To: <20080227010732.GB3066@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Tue, Feb 26, 2008 at 04:13:37PM -0700, Larry Finger wrote:
>   
>> After the BCM4311 that is built-in on my laptop failed, I bought a USB wi-fi device to use until I
>> get my laptop fixed. Based on suggestions from the wireless mailing list, I bought one with an
>> RTL8187 chip. Naturally, I am having problems getting it working.
>>
>> First of all, the device works with Windows - thus it is OK.
>>
>> The device is manufactured by "Level 1". The FCC ID is NDD9573160714 and it has the identifying code
>> of WNC-0301USB07091001070-V5.
>>
>> The output of 'lsusb -v' for this device when run as root is
>>
>> Bus 001 Device 002: ID 0bda:8187 Realtek Semiconductor Corp.
>>     
>
> This looks like it should be supported by the rtl8187 driver.
>
> <snip>
>
>   
>>   iProduct                2 RTL8187B_WLAN_Adapter
>>     
>
> <snip>
>
>   
>>         bEndpointAddress     0x83  EP 3 IN
>>     
>
> <snip>
>
> But these bits look like it is actually an rtl8187b, which is not
> supported by the driver.  I didn't know that there where some 'b'
> devices using the same USB ID as the non-b devices -- crappy vendor's
> strike again.  I'm not sure what to do about that one.
>
> As for rtl8187b support in general, I've been looking at porting
> support for those devices form the vendor-provided driver.  But the
> patch is incomplete ATM -- hopefully soon, depending on events. :-(
>
> I'm sorry you are caught in the middle.  I'll try to get that b support
> patch done soon -- hopefully we can get something working for you then.
>
>   
Thanks for the info.

If I can give you any help with the patch, please let me know. In about
another week, I will be forced to use Windows to access the Internet
(Yuck!!).

Larry

