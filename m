Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37872 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaBTJ6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:58:20 -0500
Date: Thu, 20 Feb 2014 11:58:14 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <c_ppotte@qti.qualcomm.com>,
	<djindal@qti.qualcomm.com>
Subject: Re: [PATCH] cfg80211: Pass TDLS peer capability information in
 tdls_mgmt
Message-ID: <20140220095814.GA7141@jouni.qca.qualcomm.com> (sfid-20140220_105825_049145_79D9161B)
References: <1392822952-17690-1-git-send-email-usdutt@qti.qualcomm.com>
 <1392889161.5073.15.camel@jlt4.sipsolutions.net>
 <20140220094952.GA6290@jouni.qca.qualcomm.com>
 <1392890037.5073.18.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1392890037.5073.18.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 10:53:57AM +0100, Johannes Berg wrote:
> On Thu, 2014-02-20 at 11:49 +0200, Jouni Malinen wrote:
> > On Thu, Feb 20, 2014 at 10:39:21AM +0100, Johannes Berg wrote:
> > > Generally, the patch looks fine, but I think you need to modify mac80211
> > > as well, and the mwifiex patch doesn't apply to my mac80211-next tree.
> > 
> > How do you want to handle mwifiex then? That function is in
> > wireless-testing.git and if the cfg80211 API change goes through
> > mac80211-next that does not have mwifiex change, I'd assume the build
> > will break once that gets merged into wireless-testing (or whatever is
> > the first tree getting changes from both)?
> 
> Hmm, dunno. I could merge wireless-next into mac80211-next, if that
> helps?

It looks like the patch would apply cleanly to the current snapshot of
wireless-next, so this would likely allow cleaner path for getting this
in without leaving hidden issues for future merges.

-- 
Jouni Malinen                                            PGP id EFC895FA
