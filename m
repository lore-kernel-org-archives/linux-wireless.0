Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab2GDH2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 03:28:15 -0400
Message-ID: <1341386888.4482.0.camel@jlt3.sipsolutions.net> (sfid-20120704_092819_151166_57E69356)
Subject: Re: [PATCH v1 0/2] High bitrate support
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 04 Jul 2012 09:28:08 +0200
In-Reply-To: <1341386520-25244-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341386520-25244-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 10:21 +0300, Vladimir Kondratiev wrote:
> I rephrased comments following Luis's input.
> 
> As for the name for new option, still have no idea what
> is the best name, thus leaving NL80211_RATE_INFO_BITRATE_HT

I dunno, maybe just call it _BITRATE32?

johannes

