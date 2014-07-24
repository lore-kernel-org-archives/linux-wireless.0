Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32986 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaGXK7o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 06:59:44 -0400
Message-ID: <1406199557.14675.14.camel@jlt4.sipsolutions.net> (sfid-20140724_125947_088375_2476BF68)
Subject: Re: [PATCH 2/2] mac80211: mesh_plink: use get_unaligned_le16
 instead of memcpy
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Date: Thu, 24 Jul 2014 12:59:17 +0200
In-Reply-To: <20140628205452.GB17825@localhost> (sfid-20140628_225456_436140_42A57E85)
References: <1403987726-17576-1-git-send-email-me@bobcopeland.com>
	 <1403987726-17576-2-git-send-email-me@bobcopeland.com>
	 <20140628205452.GB17825@localhost> (sfid-20140628_225456_436140_42A57E85)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-06-28 at 16:54 -0400, Bob Copeland wrote:
> [+CC linux-wireless]
> On Sat, Jun 28, 2014 at 04:35:26PM -0400, Bob Copeland wrote:
> > Use get_unaligned_le16 to access llid/plid.

Applied.

johannes

