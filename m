Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46004 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3A2K7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 05:59:46 -0500
Message-ID: <1359457210.8108.7.camel@jlt4.sipsolutions.net> (sfid-20130129_120000_862976_7D808293)
Subject: Re: WARNING: at net/mac80211/agg-tx.c:685 ieee80211_start_tx_ba_cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 29 Jan 2013 12:00:10 +0100
In-Reply-To: <87r4l7xipl.fsf@purkki.adurom.net>
References: <87vcakxzin.fsf@purkki.adurom.net>
	 <1359233629.8699.4.camel@jlt4.sipsolutions.net>
	 <87r4l7xipl.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-01-27 at 08:07 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:

> Jan 26 19:54:36 x230 kernel: [18654.186629] WARNING: at
> net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
> [mac80211]()

These must be during suspend/resume, care to post a backtrace or two
(are they all identical?)

johannes

