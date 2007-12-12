Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.polimi.it ([131.175.12.3]:48042 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282AbXLLJIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 04:08:38 -0500
From: stefano.brivio@polimi.it
Message-ID: <20071212100641.v2o9hosmwwgoo4gk@webmail.polimi.it> (sfid-20071212_090844_261978_0BE14C60)
Date: Wed, 12 Dec 2007 10:06:41 +0100
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>,
	Joseph Jezak <josejx@gentoo.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFT] b43: Fix for broken transmission
References: <200712111343.50943.mb@bu3sch.de>
	<200712111622.54086.mb@bu3sch.de>
In-Reply-To: <200712111622.54086.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Citando Michael Buesch <mb@bu3sch.de>:

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

It completely fixes my 4309. Thank you for fixing my obnoxious  
regression. John, I think that this should go into the tree as soon as  
possible (well, as soon as Michael sign it off).


--
Ciao
Stefano



