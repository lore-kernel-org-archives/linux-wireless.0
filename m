Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3KYQJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:09:41 -0500
Message-ID: <1385395776.4443.38.camel@jlt4.sipsolutions.net> (sfid-20131125_170943_945772_022365B0)
Subject: Re: [PATCH] mac80211: mesh: only get tsf if we need it
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: thomas@cozybit.com, linux-wireless@vger.kernel.org,
	Bob Copeland <bob@cozybit.com>
Date: Mon, 25 Nov 2013 17:09:36 +0100
In-Reply-To: <1384813528-30359-1-git-send-email-me@bobcopeland.com> (sfid-20131118_232822_643837_F42B8DAC)
References: <1384813528-30359-1-git-send-email-me@bobcopeland.com>
	 (sfid-20131118_232822_643837_F42B8DAC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-18 at 17:25 -0500, Bob Copeland wrote:
> The local TSF timer is used to compute the timing offset between
> mesh peers on beacon reception.  However, asking the device for
> the TSF is not very accurate, so we prefer to use rx->mactime
> if available.  In the latter case, calling drv_get_tsf() just
> adds more delay into the RX path, so skip it if we can.

Applied.

johannes

