Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab0I3W2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 18:28:42 -0400
Subject: Re: [PATCH 2/3] cfg80211: patches to allow setting the WDS peer
From: Johannes Berg <johannes@sipsolutions.net>
To: Bill Jordan <bjordan@rajant.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <AANLkTin2cVXkQ5zmQkm1Yg39Vi3Fzoy067JLBwx+RBKj@mail.gmail.com>
References: <AANLkTin2cVXkQ5zmQkm1Yg39Vi3Fzoy067JLBwx+RBKj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 00:29:15 +0200
Message-ID: <1285885755.5137.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 18:21 -0400, Bill Jordan wrote:

>  net/wireless/nl80211.c  |   49 +++++++++++++++++++++++++++++++++++++++++++++++

> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -603,6 +603,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg,
> u32 pid, u32 seq, int flags,
>  		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
>  	}
>  	CMD(set_channel, SET_CHANNEL);
> +	CMD(set_wds_peer, SET_WDS_PEER);
> 
>  #undef CMD
> 
> @@ -831,6 +832,48 @@ static int nl80211_set_channel(struct sk_buff
> *skb, struct genl_info *info)
>  	return result;
>  }
> 

This patch was somehow cut short.

Also, your patches are line-wrapped, which means they cannot be applied.

You can find information on fixing that in
Documentation/email-clients.txt, but gmail web interface simply cannot
work.

Finally, it'd be nice if you could thread your patches into the thread
opened by the 0/N patch. Maybe look at quilt?

johannes

