Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1EIR2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 13:28:55 -0400
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: sbrown@cortland.com
Cc: Ben Greear <greearb@candelatech.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1304961656.2615.9.camel@mythtv.ewol.com> (sfid-20110509_192125_083264_329C5406)
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
	 <4DC81A61.9080101@candelatech.com>
	 <1304959783.12202.7.camel@jlt3.sipsolutions.net>
	 <1304961656.2615.9.camel@mythtv.ewol.com>
	 (sfid-20110509_192125_083264_329C5406)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 19:28:51 +0200
Message-ID: <1304962131.12202.10.camel@jlt3.sipsolutions.net> (sfid-20110509_192858_902670_C24CA23F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 13:20 -0400, Steve Brown wrote:

> > 
> > If you really care greatly about having different beacon intervals (and
> > I don't see why you would?) then maybe you can think how we can enforce
> > and advertise that to userspace. For now, I'm more comfortable just
> > restricting it.
> > 
> > johannes
> 
> I posted a patch for different beacon intervals to the ath9k list last
> Jan. This was to allow both a mesh (interval 1000) and ap (interval 100)
> vif on the same radio. This combination seems useful, at least for me.

Yeah that makes some sense. Note that this patch doesn't (yet) enforce
any restrictions on mesh anyway though.

johannes

