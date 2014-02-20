Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaBTKAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 05:00:06 -0500
Message-ID: <1392890403.5073.21.camel@jlt4.sipsolutions.net> (sfid-20140220_110013_283773_C5344DA5)
Subject: Re: [PATCH] cfg80211: Pass TDLS peer capability information in
 tdls_mgmt
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, c_ppotte@qti.qualcomm.com,
	djindal@qti.qualcomm.com
Date: Thu, 20 Feb 2014 11:00:03 +0100
In-Reply-To: <20140220095814.GA7141@jouni.qca.qualcomm.com>
References: <1392822952-17690-1-git-send-email-usdutt@qti.qualcomm.com>
	 <1392889161.5073.15.camel@jlt4.sipsolutions.net>
	 <20140220094952.GA6290@jouni.qca.qualcomm.com>
	 <1392890037.5073.18.camel@jlt4.sipsolutions.net>
	 <20140220095814.GA7141@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 11:58 +0200, Jouni Malinen wrote:
> On Thu, Feb 20, 2014 at 10:53:57AM +0100, Johannes Berg wrote:
> > On Thu, 2014-02-20 at 11:49 +0200, Jouni Malinen wrote:
> > > On Thu, Feb 20, 2014 at 10:39:21AM +0100, Johannes Berg wrote:
> > > > Generally, the patch looks fine, but I think you need to modify mac80211
> > > > as well, and the mwifiex patch doesn't apply to my mac80211-next tree.
> > > 
> > > How do you want to handle mwifiex then? That function is in
> > > wireless-testing.git and if the cfg80211 API change goes through
> > > mac80211-next that does not have mwifiex change, I'd assume the build
> > > will break once that gets merged into wireless-testing (or whatever is
> > > the first tree getting changes from both)?
> > 
> > Hmm, dunno. I could merge wireless-next into mac80211-next, if that
> > helps?
> 
> It looks like the patch would apply cleanly to the current snapshot of
> wireless-next, so this would likely allow cleaner path for getting this
> in without leaving hidden issues for future merges.

Yeah I just tried that. Once Sunil resubmits the patch with the other
stuff fixed I'll merge wireless-next/master before the patch.

johannes

