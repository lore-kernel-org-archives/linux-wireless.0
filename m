Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55372 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaLOMlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 07:41:05 -0500
Message-ID: <1418647259.5731.7.camel@sipsolutions.net> (sfid-20141215_134108_757337_20C72D42)
Subject: Re: [PATCH v4] mac80211: keep sending peer candidate events while
 in listen state
From: Johannes Berg <johannes@sipsolutions.net>
To: "Nishikawa, Kenzoh" <Kenzoh.Nishikawa@jp.sony.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"Bob Copeland (me@bobcopeland.com)" <me@bobcopeland.com>,
	"Thomas Pedersen (thomas@noack.us)" <thomas@noack.us>
Date: Mon, 15 Dec 2014 13:40:59 +0100
In-Reply-To: <2EB4F5C65A3B8E4E92660930F4EF6B5B06C981@JPYOKXMS113.jp.sony.com>
References: <2EB4F5C65A3B8E4E92660930F4EF6B5B06C981@JPYOKXMS113.jp.sony.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-21 at 11:24 +0000, Nishikawa, Kenzoh wrote:

> +		cfg80211_notify_new_peer_candidate(sdata->dev, hw_addr,
> +							   elems->ie_start,
> +							   elems->total_len,
> +							   GFP_ATOMIC);

Please indent properly (to align after the opening parenthesis)

johannes

