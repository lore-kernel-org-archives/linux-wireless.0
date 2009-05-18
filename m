Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61141 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZERPl3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 11:41:29 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 08:41:31 -0700
Date: Mon, 18 May 2009 08:41:34 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stecklum@tls-tautenburg.de" <stecklum@tls-tautenburg.de>,
	"me@bobcopeland.com" <me@bobcopeland.com>,
	"breusshe@hotmail.com" <breusshe@hotmail.com>
Subject: Re: [PATCH 1/4] compat-2.6: update compat.diff
Message-ID: <20090518154134.GC20637@tesla>
References: <1242564463-9120-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1242564463-9120-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 17, 2009 at 05:47:40AM -0700, Hauke Mehrtens wrote:
> In kernel versions > 2.9.28 linux/etherdevice.h includes asm/unaligned.h.
> This is needed by net/mac80211/key.c.

All applied thanks!

  Luis
