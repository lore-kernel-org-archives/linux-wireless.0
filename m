Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50988 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab0LVUMV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 15:12:21 -0500
Message-ID: <4D125B9F.7090503@hauke-m.de>
Date: Wed, 22 Dec 2010 21:12:15 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Elvis Dowson <elvis.dowson@mac.com>
CC: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com> <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com> <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com> <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com> <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com> <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com> <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com> <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com> <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com> <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com> <4D122B8F.5090302@hauke-m.de> <1813D0B1-5391-48DB-9882-A6586DAB180C@mac.com> <AANLkTimMWH63yG2tdu7OHemHs=6OOy_i5fpeEDhhh6O9@mail.gmail.com> <4D123FBB.1050801@hauke-m.de> <C7700580-CCBB-498D-9EA5-73E2BF748C68@mac.com> <A7C7741B-634A-4C4B-A6F1-EBEA5F2EEED5@mac.com>
In-Reply-To: <A7C7741B-634A-4C4B-A6F1-EBEA5F2EEED5@mac.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/22/2010 09:03 PM, Elvis Dowson wrote:
> 
> On Dec 22, 2010, at 11:34 PM, Elvis Dowson wrote:
> 
>> However, I don't see a wl1271.ko module in the list of built files. The TI android
>> rowboard 2.6.32 kernel doesn't have an option for wl12xx or wl1271 at the moment
>> so, what do I do next? :-) 
> 
> I only see the following kernel modules :
> 
> cfg80211.ko
> compat.ko
> compat_firmware_class.ko
> mac80211.ko
> 
> Shouldn't a wl1271.ko or wl12xx,ko module be there? 
> 
> I configured compat-wireless for the wl12xx driver.
> 
> Elvis Dowson
Hi Elvis,

Looks like you did everything correct. ;-)

Is CONFIG_CRC7=y set in your kernel config, the wl12xx module needs
this? If it is not set the module will not be build.

Hauke
