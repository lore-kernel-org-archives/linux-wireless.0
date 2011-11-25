Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab1KYLZC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 06:25:02 -0500
Date: Fri, 25 Nov 2011 12:27:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
Message-ID: <20111125112732.GA19885@redhat.com> (sfid-20111125_122507_960511_AA3BCEDE)
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>
 <4EB96416.5040700@candelatech.com>
 <1320772727.24797.23.camel@jlt3.sipsolutions.net>
 <4EB9661F.9040901@candelatech.com>
 <1320775001.24797.26.camel@jlt3.sipsolutions.net>
 <4EB9703B.6030006@candelatech.com>
 <1320777531.24797.35.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1320777531.24797.35.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 08, 2011 at 07:38:51PM +0100, Johannes Berg wrote:
> I was looking at RH bug 731365 but I think Eliad's patches should have
> fixed that. But generally, that code just makes me nervous, in
> particular ieee80211_cfg_on_oper_channel(). I think all of this should
> be a lot simpler, and if it isn't that's probably due to *other* bugs
> this is working around.

So, can proceed with that revert? We just get confirmation in 
RH bug 731365, that it fix reproducible rate_control_send_low
WARNING issue (also is probable that it fix some rtlwifi problems,
but I do not have clear confirmation about that yet).

Stanislaw
