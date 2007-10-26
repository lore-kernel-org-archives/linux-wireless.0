Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38931 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbXJZVcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:32:00 -0400
Date: Fri, 26 Oct 2007 14:31:20 -0700
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] mac80211: reorder association debug output
Message-ID: <20071026213120.GA26072@kroah.com> (sfid-20071026_223205_167230_B341C039)
References: <11934326793639-git-send-email-linville@tuxdriver.com> <11934326801557-git-send-email-linville@tuxdriver.com> <11934326803769-git-send-email-linville@tuxdriver.com> <11934326803330-git-send-email-linville@tuxdriver.com> <11934326811535-git-send-email-linville@tuxdriver.com> <11934326813508-git-send-email-linville@tuxdriver.com> <1193432681145-git-send-email-linville@tuxdriver.com> <1193433039.15686.12.camel@johannes.berg> <20071026212303.GF23415@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071026212303.GF23415@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 26, 2007 at 05:23:03PM -0400, John W. Linville wrote:
> On Fri, Oct 26, 2007 at 11:10:39PM +0200, Johannes Berg wrote:
> > 
> > On Fri, 2007-10-26 at 17:04 -0400, John W. Linville wrote:
> > > From: Johannes Berg <johannes@sipsolutions.net>
> > > 
> > > There's no reason to warn about an invalid AID field when the
> > > association was denied.
> > 
> > I don't really see a reason to have this in stable, do we really want
> 
> Perhaps not.  I'm still not totally clear on the "stable" criteria
> (probably my own fault).

See Documentation/stable_kernel_rules.txt for what the "criteria" is.

thanks,

greg k-h
