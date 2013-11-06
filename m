Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab3KFKRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:17:15 -0500
Message-ID: <1383733032.14307.21.camel@jlt4.sipsolutions.net> (sfid-20131106_111740_691330_4E7C0753)
Subject: Re: [PATCH 03/19] cfg80211: check regulatory request alpha2 early
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 11:17:12 +0100
In-Reply-To: <1383671897-7746-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181718_685644_A51BF727)
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
	 <1383671897-7746-4-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131105_181718_685644_A51BF727)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-05 at 09:18 -0800, Luis R. Rodriguez wrote:
> Currently nl80211 allows userspace to send the kernel
> a bogus regulatory domain with at most 32 rules set
> and it won't reject it until after its allocated
> memory. Let's be smart about it and take advantage
> that the last_request is now available under RCU
                                               ^^^

I think you mean RTNL?

johannes

