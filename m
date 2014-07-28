Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56872 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaG1HPv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 03:15:51 -0400
Message-ID: <1406531732.29927.0.camel@jlt4.sipsolutions.net> (sfid-20140728_091555_096821_F8A45A61)
Subject: Re: [PATCHv3 0/6] configure dynack through mac80211/cfg80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Mon, 28 Jul 2014 09:15:32 +0200
In-Reply-To: <1406497008-25383-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140727_233653_349496_DBB0D24B)
References: <1406497008-25383-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20140727_233653_349496_DBB0D24B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-07-27 at 23:36 +0200, Lorenzo Bianconi wrote:
> Extend set_coverage_class API in order to enable ACK timeout estimation
> algorithm (dynack) passing coverage_class equals to -1 to lower drivers.
> Currently dynack is supported just by ath9k.
> Fix set_coverage_class signature for p54, ath9k, ath9k_htc and ath5k drivers.

You need to fix that in the same patch that changes the prototype,
otherwise you break compile in the middle ...

johannes

