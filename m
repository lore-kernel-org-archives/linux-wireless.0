Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:64446 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3ALARF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 19:17:05 -0500
Received: by mail-we0-f171.google.com with SMTP id u3so1092100wey.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2013 16:17:03 -0800 (PST)
Message-ID: <50F0AB7C.6030609@gmail.com> (sfid-20130112_011710_390508_6A2AAA5E)
Date: Sat, 12 Jan 2013 01:17:00 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] linux-firmware: add zd1211rw firmware
References: <1342543168-6666-1-git-send-email-xose.vazquez@gmail.com> <1342662412.11373.81.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1342662412.11373.81.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2012 03:46 AM, Ben Hutchings wrote:

> On Tue, 2012-07-17 at 18:39 +0200, Xose Vazquez Perez wrote:
>> firmware for zd1211rw, ZyDAS/Atheros ZD1211/ZD1211B/AR5007UG wireless driver.
>>
>> Cc: Daniel Drake <dsd@gentoo.org>
>> Cc: Ulrich Kunitz <kune@deine-taler.de>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Ben Hutchings <ben@decadent.org.uk>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>> README
>>
>> This distribution contains the firmware files for the
>> ZD1211 chip, which is used in WLAN USB sticks. Copy the zd1211_* files to
>> /lib/firmware/zd1211, where they can be loaded by the rewritten
>> zd1211 driver.
>>
>> The files are generated from C header files distributed in the
>> original ZyDAS ZD1211 driver under the GNU Public License.
>>
>> The full source of the original ZYDAS driver is available from
>> http://zd1211.wiki.sourceforge.net/VendorDriver
>>
>> The GPL-licensed header files used to produce the firmware blobs are also
>> present in this distribution.
> [...]
> 
> Not in this patch, though.
> 
> And if you're referring to C sources with arrays of bytes - this is not
> really the preferred form for modification, so the blobs cannot be
> distributed under the GNU GPL.  This is surely a mistake by the
> copyright holder, but they need to clarify the licence that was really
> intended for the firmware.
> 
> (There were some in-tree drivers where this same mistake was made, for
> which you will see in WHENCE: 'Allegedly GPLv2+, but no source visible'.
> These are kept in linux-firmware to avoid regression of those drivers.
> The unclear licence does pose some legal risk, but hopefully no more
> than previously existed with the blobs embedded in the kernel source.
> However, I don't see any reason to accept bogus licence information for
> blobs that were not previously included in the kernel source.)

Well, there is no source code of this firmware. And the original
hardware manufacturer was bought a long time ago by Atheros, later
Atheros by Qualcomm. So there is no one to contact.

This is a dead end for me, I can't do any more.

If someone needs this firmware, it can be downloaded from:
http://sourceforge.net/projects/zd1211/files/

-thank you-
