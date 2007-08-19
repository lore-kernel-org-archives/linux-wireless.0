Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:61420 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753898AbXHSQHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 12:07:12 -0400
Message-ID: <46C86AA4.1030303@lwfinger.net>
Date: Sun, 19 Aug 2007 11:07:00 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Lock problem with latest b43 patches
References: <46C7CACC.2000000@lwfinger.net> <200708191416.26192.mb@bu3sch.de>
In-Reply-To: <200708191416.26192.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Sunday 19 August 2007 06:45:00 Larry Finger wrote:
>> Using the latest set of 6 patches posted about 5 hours ago, I get the following locking problem with 
>> a BCM4311 using WPA-PSK TKIP encryption controlled by NetworkManager:
> 
> Are you sure this is caused by my patches? I don't see how that's possible.
> How to reproduce?

It's probably not your patches, but some unusual locking interaction involving NetworkManager, 
wpa_supplicant, and mac80211. The involvement of b43 may be incidental. It must have accidentally 
triggered just after I installed your patches. I cannot reproduce it today. No doubt it will show up 
again.

Larry
