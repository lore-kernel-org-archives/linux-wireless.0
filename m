Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:50583 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312AbYLJQpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 11:45:02 -0500
Message-ID: <493FF20C.5070607@lwfinger.net> (sfid-20081210_174507_900922_9B8B2EAB)
Date: Wed, 10 Dec 2008 10:45:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix sparse warnings
References: <493f552d.zivnzjivWDMPej+O%Larry.Finger@lwfinger.net> <200812101133.54173.mb@bu3sch.de>
In-Reply-To: <200812101133.54173.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 10 December 2008 06:35:41 Larry Finger wrote:
>>   CHECK   drivers/net/wireless/b43legacy/debugfs.c
>> drivers/net/wireless/b43legacy/debugfs.c:243:9: warning: memset with byte count of 131072
> 
> I know about this error and I think it's a damn stupid error.
> There is a reason why the value was so high in b43. I don't know about b43legacy.
> Did you check if all callbacks still work properly?

Yes. AFAIK, everything works correctly. BTW, I chose 16 KiB because that is the
number in b43, and I expected the two drivers to need about the same amount of
buffer space. Was that a bad assumption?

Larry
