Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934929Ab2JYL2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 07:28:21 -0400
Message-ID: <1351164533.10421.3.camel@jlt4.sipsolutions.net> (sfid-20121025_132824_856590_EDFBE38A)
Subject: Re: [PATCH] mac80211: remove duplicate check in
 ieee80211_rx_mgmt_beacon().
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 25 Oct 2012 13:28:53 +0200
In-Reply-To: <1351152983-13871-1-git-send-email-ramirose@gmail.com> (sfid-20121025_081705_470514_2E00E8AC)
References: <1351152983-13871-1-git-send-email-ramirose@gmail.com>
	 (sfid-20121025_081705_470514_2E00E8AC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-25 at 10:16 +0200, Rami Rosen wrote:
> This patch removes a duplicate identical check in ieee80211_rx_mgmt_beacon(), mlme.c.
> There is no need to make again the same check for IEEE80211_HW_PS_NULLFUNC_STACK
> flag. It should be done in the same block.

Applied.

johannes

