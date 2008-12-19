Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54125 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbYLSO4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 09:56:34 -0500
Date: Fri, 19 Dec 2008 16:56:16 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Jouni.Malinen@atheros.com
Subject: Re: [PATCH] [RFC] mac80211: Disable HT negotiation with TKIP/WEP
	as pairwise cipher
Message-ID: <20081219145616.GA12018@jm.kir.nu> (sfid-20081219_155637_848492_1FBD53C4)
References: <1229692235-21734-1-git-send-email-vasanth@atheros.com> <20081219142822.GA4041@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081219142822.GA4041@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 09:28:22AM -0500, John W. Linville wrote:
> Are there perhaps any broken APs out there that support such a
> configuration?  I would hate to prevent users from connecting simply
> out of blind obedience to the standard.

The goal of this change is _not_ to prevent connection, it only disables
HT association, i.e., legacy (11a/g/b) is still available.

-- 
Jouni Malinen                                            PGP id EFC895FA
