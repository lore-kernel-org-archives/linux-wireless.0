Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:45500 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114AbYABTr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 14:47:59 -0500
Message-ID: <477BEA68.7090201@lwfinger.net> (sfid-20080102_194803_152795_235E469A)
Date: Wed, 02 Jan 2008 11:47:52 -0800
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Fix rxheader channel parsing
References: <200801021855.53410.mb@bu3sch.de> <477BDD58.9050702@lwfinger.net> <200801022002.58434.mb@bu3sch.de>
In-Reply-To: <200801022002.58434.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
>> Shouldn't you just drop this case? No B PHY devices will ever use b43 and the default branch will
>> issue the WARN_ON anyway.
> 
> I guess you misread the patch.
> 

I did indeed. Sorry.

Larry

