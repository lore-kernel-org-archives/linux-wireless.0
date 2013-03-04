Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab3CDUYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:24:05 -0500
Message-ID: <1362428638.21028.51.camel@jlt4.sipsolutions.net> (sfid-20130304_212410_722218_6D806EC2)
Subject: Re: [PATCH] regulatory: enable channels 52-144 for world roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@do-not-panic.com" <mcgrof@do-not-panic.com>
Date: Mon, 04 Mar 2013 21:23:58 +0100
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9D8DA3D2@SC-VEXCH1.marvell.com>
References: <1362427007-4493-1-git-send-email-johannes@sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F70430D9D8DA3D2@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

> > -		/* NB: 5260 MHz - 5700 MHz requires DFS */
> > +		/* IEEE 802.11a, channel 52..144 - DFS required */
> > +		REG_RULE(5760-10, 5720+10, 80, 6, 20,
> 
> 5260-10

Umm, yes, good catch. Thanks!

johannes

