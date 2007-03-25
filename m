Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:45343 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932437AbXCYSXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2007 14:23:55 -0400
Message-ID: <4606BE34.7000705@lwfinger.net>
Date: Sun, 25 Mar 2007 13:23:48 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix machine check on PPC for version 1 PHY
References: <46067d12.1uF8l72xIYAG6Vyb%Larry.Finger@lwfinger.net>	 <200703251613.23880.mb@bu3sch.de> <1174841628.20505.244.camel@pmac.infradead.org>
In-Reply-To: <1174841628.20505.244.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> On Sun, 2007-03-25 at 16:13 +0200, Michael Buesch wrote:
>> I'm not sure this patch is complete.
>> Joseph made changes to the specs that should fix the issue completely.
>> I didn't look at the changes, yet. 
> 
> I don't see relevant changes in the v3 specs. I was working empirically,
> reverting parts of the large patch which broke it.

There aren't any. Joseph is making the changes to the V4 specs, most of which are valid for V3 as
well. If I have any questions, I ask him privately.

Larry

