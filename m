Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19466 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab0JAAZ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 20:25:28 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 17:25:20 -0700
Date: Thu, 30 Sep 2010 17:25:26 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Bill Jordan <bjordan@rajant.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 2/3] cfg80211: patches to allow setting the WDS peer
Message-ID: <20101001002526.GC8930@tux>
References: <AANLkTin2cVXkQ5zmQkm1Yg39Vi3Fzoy067JLBwx+RBKj@mail.gmail.com>
 <1285885755.5137.23.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1285885755.5137.23.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 30, 2010 at 03:29:15PM -0700, Johannes Berg wrote:
> On Thu, 2010-09-30 at 18:21 -0400, Bill Jordan wrote:
> 
> >  net/wireless/nl80211.c  |   49 +++++++++++++++++++++++++++++++++++++++++++++++
> 
> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -603,6 +603,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg,
> > u32 pid, u32 seq, int flags,
> >  		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
> >  	}
> >  	CMD(set_channel, SET_CHANNEL);
> > +	CMD(set_wds_peer, SET_WDS_PEER);
> > 
> >  #undef CMD
> > 
> > @@ -831,6 +832,48 @@ static int nl80211_set_channel(struct sk_buff
> > *skb, struct genl_info *info)
> >  	return result;
> >  }
> > 
> 
> This patch was somehow cut short.
> 
> Also, your patches are line-wrapped, which means they cannot be applied.
> 
> You can find information on fixing that in
> Documentation/email-clients.txt, but gmail web interface simply cannot
> work.

You can use git sende-mail as documented on that link I gave you, Bill.
> 
> Finally, it'd be nice if you could thread your patches into the thread
> opened by the 0/N patch. Maybe look at quilt?

And this is accomplished with --no-chain-reply-to git send-email as
mentioned in the same guide.

  Luis
