Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3JAKRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 06:17:25 -0400
Message-ID: <1380622642.14430.5.camel@jlt4.sipsolutions.net> (sfid-20131001_121727_829481_B7BCD78D)
Subject: Re: [PATCH 3/3] mac80211: allow configuring smps_mode_in_ps
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Date: Tue, 01 Oct 2013 12:17:22 +0200
In-Reply-To: <1377852561-16754-3-git-send-email-johannes@sipsolutions.net> (sfid-20130830_104935_274969_0AC9B6AF)
References: <1377852561-16754-1-git-send-email-johannes@sipsolutions.net>
	 <1377852561-16754-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130830_104935_274969_0AC9B6AF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-30 at 10:49 +0200, Johannes Berg wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> When in automatic smps mode (default for station mode),
> mac80211 configures dynamic smps when the station enters
> powersave.
> 
> However, drivers might prefer using different modes in this
> case (e.g. due to major throughput degradation).
> 
> Add a new hw->smps_mode_in_ps field that can be configured
> by the driver in order to override the default smps dynamic mode.

Dropping this, we ended up not wanting/needing it.

johannes

