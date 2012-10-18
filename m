Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2JRPVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 11:21:23 -0400
Message-ID: <1350573714.10638.19.camel@jlt4.sipsolutions.net> (sfid-20121018_172127_250729_05BE4ED1)
Subject: Re: [PATCHv3] nl/cfg80211: force scan using an AP vif if requested
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 18 Oct 2012 17:21:54 +0200
In-Reply-To: <1350369562-24733-1-git-send-email-ordex@autistici.org>
References: <1350369562-24733-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-16 at 08:39 +0200, Antonio Quartulli wrote:
> If the user wants to scan using a vif configured as AP, cfg80211 must give him a
> chance to do it, even if this will disrupt the stations performance due to
> off-channel scanning. To do so, this patch adds a 'force' flag to the
> SCAN_TRIGGER command which tells cfg80211 to perform the scanning operation even
> if the vif is an AP and the beaconing has already started.

Applied, but please break commit logs to < 72 characters in the future
yourself.

johannes

