Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45710 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbbK0Jwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 04:52:51 -0500
Message-ID: <1448617968.2531.33.camel@sipsolutions.net> (sfid-20151127_105255_569559_D1AF819B)
Subject: Re: [PATCH v2 6/8] cfg80211: reg: Add NL80211_RRF_USER_REGD_NEEDED
 flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Sojka <sojkam1@fel.cvut.cz>, linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	Jan =?ISO-8859-1?Q?Kaisrl=EDk?= <kaisrja1@fel.cvut.cz>
Date: Fri, 27 Nov 2015 10:52:48 +0100
In-Reply-To: <87si3r22w0.fsf@steelpick.2x.cz>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
	 <1448303241-27747-7-git-send-email-sojkam1@fel.cvut.cz>
	 <1448613316.2531.13.camel@sipsolutions.net>
	 <87si3r22w0.fsf@steelpick.2x.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-11-27 at 10:43 +0100, Michal Sojka wrote:

> What do you mean by "show"? nl80211_put_regdom() already sends regdom
> flags to userspace. Or do you mean introducing a new channel
> attribute and send it in nl80211_msg_put_channel()?
> 

No, I meant keeping the flag - so that people can know with "iw list"
or something that they need a special regdomain to enable the channels?

johannes
