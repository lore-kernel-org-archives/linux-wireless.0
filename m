Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52429 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab3ADPq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 10:46:59 -0500
Message-ID: <1357314443.11302.21.camel@jlt4.sipsolutions.net> (sfid-20130104_164703_695627_E3CD04D1)
Subject: Re: [PATCH v2] iw: print capability info for DMG (60GHz band)
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 04 Jan 2013 16:47:23 +0100
In-Reply-To: <15592562.1rgtRnahzt@lx-vladimir>
References: <3409795.QNLPYz7pkM@lx-vladimir>
	 <1356082023.9580.5.camel@jlt4.sipsolutions.net>
	 <15592562.1rgtRnahzt@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-12-23 at 10:36 +0200, Vladimir Kondratiev wrote:
> On Friday, December 21, 2012 10:27:03 AM Johannes Berg wrote:
> > On Mon, 2012-12-17 at 13:32 +0200, Vladimir Kondratiev wrote:
> > > From cc320b6c4433b63f3b1641646a49c4540e8954d2 Mon Sep 17 00:00:00 2001
> > > From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> > > Date: Mon, 17 Dec 2012 13:31:36 +0200
> > > Subject: [PATCH] iw: print capability info for 60GHz band
> > > 
> > > On the 60GHz band, capability info defined different from .11n
> > 
> > I would prefer you didn't use "11ad" or "11n", in particular not "11n",
> > it hasn't existed for quite a while now.
> > 
> > Also, the 2.4/5ghz capability bits really have nothing to do with 11n
> > anyway.
> > 
> > johannes
> 
> Well, agree, I rephrased. Also, squash these 2:
> 
> [PATCH] iw: print capability info for 60GHz band
> [PATCH] iw: print all capability bits
> 
> Combined patch follows
> 
> From e79a5515929c6d4cab691e96e51f2616d7602240 Mon Sep 17 00:00:00 2001
> From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> Date: Mon, 17 Dec 2012 13:31:36 +0200
> Subject: [PATCH v2] iw: print capability info for DMG (60GHz band)
> 
> On the DMG (Directed Multi-Gigabit) aka 60GHz band, capability info
> defined by the 802.11ad spec differently from non-DMG one
> 
> Detect DMG band by frequency, spec says DMG if above 45 GHz;
> parse and print accordingly
> 
> For the non-DMG capability info, add more bits as defined in the
> IEEE802.11-2012

Applied, thanks.

johannes

