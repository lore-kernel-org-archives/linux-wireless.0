Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:30592 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbZBMV2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 16:28:50 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1630732wfa.4
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 13:28:49 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 13 Feb 2009 13:28:48 -0800
Message-ID: <63f9d2650902131328u11fd3612g496c24c47a3e6ac6@mail.gmail.com> (sfid-20090213_222852_502653_023FFABB)
Subject: Re: ath5k master (AP) mode
From: Jeff Tchang <jeff.tchang@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Wed, Feb 11, 2009 at 1:47 PM, Norman Rie <norman@smash-net.org> wrote:
>
>> Hello,
>>
>> i pulled wireless-testing kernel today and installed hostapd-0.6.7,  but
>> it still does not work.
>>
>>
>> iwconfig wlan0 mode master
>> Error for wireless request "Set Mode" (8B06) :
>>    SET failed on device wlan0 ; Invalid argument.

I am also trying to get ath5k Master/AP mode working with my wireless card.

I am using a GIGABYTE GN-WS50G 802.11 b/g Atheros AR5007 chipset
minicard mPCI express.

It gets detected as PCI ID: 168c:001c. I am using Ubuntu 8.10.

I downloaded the latest tarball from
http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
and then patched the single file adding in the option for AP mode. I
unloaded the ath5k module and then reloaded it using modprobe. However
I am still getting the "SET failed on device wlan0 ; Invalid
argument."

Using hostapd 0.6.7 I see the errors:

Failed to set interface wlan0 to master mode.
nl80211 driver initialization failed

Trying to figure out what I am missing.
