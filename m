Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39607 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965726AbcAZNLe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 08:11:34 -0500
Message-ID: <1453813892.2759.43.camel@sipsolutions.net> (sfid-20160126_141141_633262_218F89E5)
Subject: Re: [PATCH 1/2] mac80211: fix txq queue related crashes
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 26 Jan 2016 14:11:32 +0100
In-Reply-To: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com> (sfid-20160121_142159_483215_F2BFFEA2)
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160121_142159_483215_F2BFFEA2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-21 at 14:23 +0100, Michal Kazior wrote:
> The driver can access the queue simultanously
> while mac80211 tears down the interface. Without
> spinlock protection this could lead to corrupting
> sk_buff_head and subsequently to an invalid
> pointer dereference.
> 
Applied.

johannes
