Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45367 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbaGUKYq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 06:24:46 -0400
Message-ID: <1405938272.32255.19.camel@jlt4.sipsolutions.net> (sfid-20140721_122506_152367_05490242)
Subject: Re: [PATCH] wireless: fixup genregdb.awk for remove of antenna gain
 from wireless-regd
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	john@x109.net, chaitanya.mgit@gmail.com, linville@tuxdriver.com,
	gregkh@linuxfoundation.org, tiwai@suse.de, keescook@chromium.org,
	nbd@openwrt.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Mon, 21 Jul 2014 12:24:32 +0200
In-Reply-To: <1405372789-24733-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140714_232013_505482_28009B17)
References: <1405372789-24733-1-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20140714_232013_505482_28009B17)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-07-14 at 14:19 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> Since "wireless-regdb: remove antenna gain" was merged in the
> wireless-regdb tree, the awk script parser has been incompatible
> with the 'official' regulatory database.  This fixes that up.
> Without this change the max EIRP is set to 0 making 802.11 devices
> useless.
> 
> The fragile nature of the awk parser must be replaced, but ideas
> over how to do that in the most scalable way are being reviewed.
> In the meantime update the documentation for CFG80211_INTERNAL_REGDB
> so folks are aware of expectations for now.

Applied.

johannes

