Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4342 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbYE3U6V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 16:58:21 -0400
Date: Fri, 30 May 2008 16:22:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH] iwl4965: remove useless network and duplicate checking
Message-ID: <20080530202212.GA21212@tuxdriver.com> (sfid-20080530_225825_850223_E728C2C7)
References: <1211446997.3698.47.camel@johannes.berg> <1ba2fa240805220341g69f3acb0qf03594f541232337@mail.gmail.com> <1212175035.7238.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1212175035.7238.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 30, 2008 at 09:17:15PM +0200, Johannes Berg wrote:
> 
> > > The iwlwifi drivers go to great lengths to avoid passing packets to
> > > mac80211 they think shouldn't go there, while mac80211 can (of course!)
> > > handle them very well.
> > >
> > > Especially in the case of duplicate packets this is interesting
> > > because it's such a performance hog (especially for IBSS networks)
> > > while mac80211 does that work on the side without much effort.
> > >
> > > This patch removes all that and leaves only what is absolutely
> > > necessary for the hardware.
> 
> 
> > Looks good to me. let me just repost it rebased over our latest code.
> 
> ping? This one no longer applies.

Was going to ask about that one myself...

-- 
John W. Linville
linville@tuxdriver.com
