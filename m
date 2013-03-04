Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3CDU7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:59:18 -0500
Message-ID: <1362430751.21028.59.camel@jlt4.sipsolutions.net> (sfid-20130304_215921_503907_6AF752CE)
Subject: Re: [PATCH v3] regulatory: enable channels 52-64 and 100-144 for
 world roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@do-not-panic.com" <mcgrof@do-not-panic.com>
Date: Mon, 04 Mar 2013 21:59:11 +0100
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9D8DA3E5@SC-VEXCH1.marvell.com>
References: <1362429852-9712-1-git-send-email-johannes@sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F70430D9D8DA3E5@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 12:49 -0800, Bing Zhao wrote:
> [...]
> 
> > +		/* IEEE 802.11a, channel 100..144 - DFS required */
> > +		REG_RULE(5500-10, 5320+10, 160, 6, 20,
> 
> 5720+10

Meh, thanks. I'm just going to get some sleep and try again tomorrow.

johannes

