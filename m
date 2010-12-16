Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab0LPS4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 13:56:35 -0500
Subject: Re: [PATCH 3/3 v2] mac80211: Send mesh non-HWMP path selection
 frames to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1292524200-14791-3-git-send-email-javier@cozybit.com>
References: <1292234643.3539.6.camel@jlt3.sipsolutions.net>
	 <1292524200-14791-3-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 19:56:33 +0100
Message-ID: <1292525793.3612.30.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 10:30 -0800, Javier Cardona wrote:
> Let path selection frames for protocols other than HWMP be sent to
> userspace via NL80211_CMD_REGISTER_FRAME.  Also allow userspace to send
> and receive mesh path selection frames.

Looks fine, thanks.

johannes

