Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab2LKTwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 14:52:36 -0500
Message-ID: <1355255577.9819.14.camel@jlt4.sipsolutions.net> (sfid-20121211_205240_382141_BC24AD77)
Subject: Re: [RFCv3 5/5] nl80211: allow userspace to access mesh power mode
 parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Date: Tue, 11 Dec 2012 20:52:57 +0100
In-Reply-To: <1354918443-3076-6-git-send-email-marco@cozybit.com> (sfid-20121207_231445_767326_6747B792)
References: <1354918443-3076-1-git-send-email-marco@cozybit.com>
	 <1354918443-3076-6-git-send-email-marco@cozybit.com>
	 (sfid-20121207_231445_767326_6747B792)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-07 at 14:14 -0800, Marco Porsch wrote:

> +	[NL80211_MESHCONF_POWER_MODE] = { .type = NLA_U8 },

I think u32 makes more sense for an enum, even if we're probably never
going to use the space, it would be more consistent with other enums.
Also, a u8 attribute really takes the same space anyway, afaik.

johannes

