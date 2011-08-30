Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1H3MSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 08:18:20 -0400
Subject: Re: [PATCH] ath5k: Invoke irqsafe version of ieee80211_tx_status()
 to avoid deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com, me@bobcopeland.com,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1314236064-6339-1-git-send-email-thomas@cozybit.com> (sfid-20110825_033444_439163_B9A65422)
References: <1314236064-6339-1-git-send-email-thomas@cozybit.com>
	 (sfid-20110825_033444_439163_B9A65422)
Content-Type: text/plain
Date: Tue, 30 Aug 2011 14:18:17 +0200
Message-ID: <1314706697.4011.24.camel@jlt3.sipsolutions.net> (sfid-20110830_141824_282505_A0065757)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, NACK. You shouldn't mix rx() with tx_status_irqsafe().

johannes

