Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41647 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaK1PLf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 10:11:35 -0500
Message-ID: <1417187490.27562.18.camel@sipsolutions.net> (sfid-20141128_161138_263744_E6B199A5)
Subject: Re: [PATCH] cfg80211: do not check for carrier during
 start_radar_detect
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: linville@tuxdriver.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com
Date: Fri, 28 Nov 2014 16:11:30 +0100
In-Reply-To: <1417174127-24712-1-git-send-email-patila@marvell.com>
References: <1417174127-24712-1-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-28 at 16:58 +0530, Avinash Patil wrote:
> Radar detection happens before starting AP; so netdev carrier may be dormant
> at this time. Remove this check from cfg80211_start_radar_detection.

Looks fine to me, but I wonder how it ever worked?

johannes

