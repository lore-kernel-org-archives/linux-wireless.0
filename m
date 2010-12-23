Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout026.mac.com ([17.148.16.101]:46152 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0LWJpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 04:45:15 -0500
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp026.mac.com (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep
 26 2008; 64bit)) with ESMTPSA id <0LDV00ES7KFBFJ40@asmtp026.mac.com> for
 linux-wireless@vger.kernel.org; Thu, 23 Dec 2010 01:45:15 -0800 (PST)
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4D1266FA.7080305@hauke-m.de>
Date: Thu, 23 Dec 2010 13:44:57 +0400
Message-id: <6DEF6718-7B40-4D95-BA2E-C73026C4384A@mac.com>
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
 <A7C7741B-634A-4C4B-A6F1-EBEA5F2EEED5@mac.com> <4D125B9F.7090503@hauke-m.de>
 <A8ED3E8F-FA2A-46B9-95C6-F2C175581539@mac.com> <4D1266FA.7080305@hauke-m.de>
To: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Dec 23, 2010, at 1:00 AM, Hauke Mehrtens wrote:

> You also have to backport the CONFIG_WL12XX_PLATFORM_DATA and activate
> it in your kernel config, wl1271_sdio depends on that.

Has anyone on the list backported CONFIG_WL12XX_PLATFORM_DATA to 
2.6.32, and got wl1271_sdio.ko to build?

Elvis Dowson
