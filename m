Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1EMOdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 10:33:40 -0400
Subject: Re: concurrency advertising -- driver maintainers
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <19917.16659.841512.824060@gargle.gargle.HOWL> (sfid-20110513_163055_280327_3B94A6EF)
References: <1305290657.3487.32.camel@jlt3.sipsolutions.net>
	 <1305294053.3487.37.camel@jlt3.sipsolutions.net>
	 <19917.16659.841512.824060@gargle.gargle.HOWL>
	 (sfid-20110513_163055_280327_3B94A6EF)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 16:33:37 +0200
Message-ID: <1305297217.3468.1.camel@jlt3.sipsolutions.net> (sfid-20110513_163344_216103_A052DB1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 20:02 +0530, Sujith wrote:
> Johannes Berg wrote:
> > On Fri, 2011-05-13 at 14:44 +0200, Johannes Berg wrote:
> > 
> > > The affected drivers, as far as I can tell, are:
> > 
> > I forgot ath9k_htc, which needs to advertise something afaict (two
> > interfaces seem to be supported)
> 
> The limitation of two is artificial, more can actually be supported.
> The firmware has to be updated, though.

Ok, but no matter what the limitation is or whether it can be changed it
should be advertised with the new advertising feature I submitted,
that's what I wanted you to do :)

johannes

