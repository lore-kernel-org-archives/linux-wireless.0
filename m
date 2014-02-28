Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaB1H4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 02:56:46 -0500
Message-ID: <1393574198.4133.0.camel@jlt4.sipsolutions.net> (sfid-20140228_085650_653413_74834A39)
Subject: Re: [PATCH 5/9] mwifiex: stop AP at shutdown time
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@alum.mit.edu>,
	Avery Pennarun <apenwarr@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Date: Fri, 28 Feb 2014 08:56:38 +0100
In-Reply-To: <1393558517-887-3-git-send-email-bzhao@marvell.com> (sfid-20140228_043533_674886_AC58C7E4)
References: <1393558517-887-1-git-send-email-bzhao@marvell.com>
	 <1393558517-887-3-git-send-email-bzhao@marvell.com>
	 (sfid-20140228_043533_674886_AC58C7E4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-27 at 19:35 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Deauth is sent to AP when the device is acting as station at
> shutdown time. Similarly we should stop AP operation also.
> mwifiex_deauthenticate() takes care closing the connection
> based on provided interface type.

Wouldn't all this be handled by cfg80211 anyway?

johannes

