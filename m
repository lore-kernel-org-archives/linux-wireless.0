Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58493 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1KYL3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 06:29:16 -0500
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20111125112732.GA19885@redhat.com> (sfid-20111125_122507_960511_AA3BCEDE)
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>
	 <4EB96416.5040700@candelatech.com>
	 <1320772727.24797.23.camel@jlt3.sipsolutions.net>
	 <4EB9661F.9040901@candelatech.com>
	 <1320775001.24797.26.camel@jlt3.sipsolutions.net>
	 <4EB9703B.6030006@candelatech.com>
	 <1320777531.24797.35.camel@jlt3.sipsolutions.net>
	 <20111125112732.GA19885@redhat.com> (sfid-20111125_122507_960511_AA3BCEDE)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Nov 2011 12:29:09 +0100
Message-ID: <1322220549.4123.7.camel@jlt3.sipsolutions.net> (sfid-20111125_122920_824626_03174F27)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-25 at 12:27 +0100, Stanislaw Gruszka wrote:
> On Tue, Nov 08, 2011 at 07:38:51PM +0100, Johannes Berg wrote:
> > I was looking at RH bug 731365 but I think Eliad's patches should have
> > fixed that. But generally, that code just makes me nervous, in
> > particular ieee80211_cfg_on_oper_channel(). I think all of this should
> > be a lot simpler, and if it isn't that's probably due to *other* bugs
> > this is working around.
> 
> So, can proceed with that revert? We just get confirmation in 
> RH bug 731365, that it fix reproducible rate_control_send_low
> WARNING issue (also is probable that it fix some rtlwifi problems,
> but I do not have clear confirmation about that yet).

Ok let's do it -- I have this patch for upstream, can you later provide
the one for stable?

johannes

