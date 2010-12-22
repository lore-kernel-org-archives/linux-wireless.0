Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout027.mac.com ([17.148.16.102]:47698 "EHLO
	asmtpout027.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0LVUEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 15:04:15 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp027.mac.com (Oracle Communications Messaging Exchange Server 7u4-18.01
 64bit (built Jul 15 2010)) with ESMTPSA id <0LDU00KLZIEYD130@asmtp027.mac.com>
 for linux-wireless@vger.kernel.org; Wed, 22 Dec 2010 12:04:13 -0800 (PST)
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <C7700580-CCBB-498D-9EA5-73E2BF748C68@mac.com>
Date: Thu, 23 Dec 2010 00:03:57 +0400
Message-id: <A7C7741B-634A-4C4B-A6F1-EBEA5F2EEED5@mac.com>
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com>
 <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com>
 <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com>
 <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
 <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com>
 <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
 <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com>
 <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com>
 <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com>
 <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com>
 <4D122B8F.5090302@hauke-m.de> <1813D0B1-5391-48DB-9882-A6586DAB180C@mac.com>
 <AANLkTimMWH63yG2tdu7OHemHs=6OOy_i5fpeEDhhh6O9@mail.gmail.com>
 <4D123FBB.1050801@hauke-m.de> <C7700580-CCBB-498D-9EA5-73E2BF748C68@mac.com>
To: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Dec 22, 2010, at 11:34 PM, Elvis Dowson wrote:

> However, I don't see a wl1271.ko module in the list of built files. The TI android
> rowboard 2.6.32 kernel doesn't have an option for wl12xx or wl1271 at the moment
> so, what do I do next? :-) 

I only see the following kernel modules :

cfg80211.ko
compat.ko
compat_firmware_class.ko
mac80211.ko

Shouldn't a wl1271.ko or wl12xx,ko module be there? 

I configured compat-wireless for the wl12xx driver.

Elvis Dowson
