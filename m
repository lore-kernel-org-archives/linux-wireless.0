Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2421 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXJ0Mun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 08:50:43 -0400
Date: Sat, 27 Oct 2007 08:50:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: reorder association debug output
Message-ID: <20071027125025.GC16222@tuxdriver.com> (sfid-20071027_135046_435282_F05DC60E)
References: <11934326793639-git-send-email-linville@tuxdriver.com> <11934326801557-git-send-email-linville@tuxdriver.com> <11934326803769-git-send-email-linville@tuxdriver.com> <11934326803330-git-send-email-linville@tuxdriver.com> <11934326811535-git-send-email-linville@tuxdriver.com> <11934326813508-git-send-email-linville@tuxdriver.com> <1193432681145-git-send-email-linville@tuxdriver.com> <1193433039.15686.12.camel@johannes.berg> <20071026212303.GF23415@tuxdriver.com> <1193435078.15686.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1193435078.15686.14.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 26, 2007 at 11:44:38PM +0200, Johannes Berg wrote:
> 
> > Anyway, this probably got caught-up in a "what recent fixes still
> > apply to 2.6.23" sweep.  Still, I don't see why this wouldn't be
> > desirable for someone running 2.6.23?
> 
> No drivers in 2.6.23 anyway and Intel ships their own mac80211. Why
> should we care at all?

rtl8187 is in 2.6.23.

-- 
John W. Linville
linville@tuxdriver.com
