Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:44716 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564AbXLLHtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 02:49:43 -0500
Message-ID: <475F926C.2000003@lwfinger.net> (sfid-20071212_074947_201736_5C8E4577)
Date: Tue, 11 Dec 2007 23:49:00 -0800
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Stefano Brivio <stefano.brivio@polimi.it>,
	Joseph Jezak <josejx@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFT] b43: Fix for broken transmission
References: <200712111343.50943.mb@bu3sch.de> <200712111622.54086.mb@bu3sch.de>
In-Reply-To: <200712111622.54086.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Tuesday 11 December 2007 13:43:50 Michael Buesch wrote:
>> This patch fixes the transmission problems introduced by
>> commit f04b3787bbce4567e28069a9ec97dcd804626ac7
>>
>> It depends on
>> [PATCH] b43: Fix ofdmtab write regression
>>
>> I'm not sure if the dummy read is really required.
>> The old code does it. I think it can't hurt and can possibly
>> fix some write posting problems (hardware bugs or whatever. Who knows).
>>
>> Please test this.
>>
>> NOT-signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> Here's an updated version that should fix even more bugs:
> http://bu3sch.de/patches/wireless-2.6/20071211-1622/patches/005-b43-fix-init-rewrite-breakage.patch

This patch (and its predecessor) seem to make transmission at the OFDM rates a bit more reliable on 
my BCM4311/2 card.

Larry
