Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35163 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0LCTPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 14:15:10 -0500
Date: Fri, 3 Dec 2010 14:11:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/31] wireless: Marvell mwifiex driver for SD8787
Message-ID: <20101203191130.GD2348@tuxdriver.com>
References: <1291253516-17815-1-git-send-email-bzhao@marvell.com>
 <1291380780.3499.119.camel@jlt3.sipsolutions.net>
 <477F20668A386D41ADCC57781B1F704307D59F9D6D@SC-VEXCH1.marvell.com>
 <77956EDC1B917843AC9B7965A3BD78B058FEF48E24@SC-VEXCH2.marvell.com>
 <1291401568.3499.142.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291401568.3499.142.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 03, 2010 at 07:39:28PM +0100, Johannes Berg wrote:
> On Fri, 2010-12-03 at 09:01 -0800, Frank Huang wrote:
> 	
> > [snip]
> 
> Mind you, there will definitely be more things to change in this
> driver ... that was just the tip of the iceberg really.

FWIW, I think it would be worthwhile to remove the uAP bits, at least
for working towards the initial merge.  That can live out of tree
at least for now.

That will remove some of the wireless events stuff.  Probably the
other wireless events stuff can be removed as well.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
