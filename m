Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58610 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752994AbZKJKDW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 05:03:22 -0500
Date: Tue, 10 Nov 2009 11:03:00 +0100
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: linux-wireless@vger.kernel.org
Subject: Re: Getting random regulatory domains on boot-up with ath9k
Message-ID: <20091110100300.GE5348@jigsaw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2da21fe50911060317v55acefdvfac01821b5f9cb0f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Davide Pesavento wrote:
> Confirmed on wireless-testing v2.6.32-rc6-wl-41575-g5e68bfb with an
> AR5418 card using ath9k. Also 'iw reg set <country code>' stopped
> working. Last known working kernel is v2.6.32-rc5-wl-40584-g9b469da.

I noticed this as well with ath9k on 2.6.32-rc6. Has this been fixed
already? If not I could spend some time trying to find the patch that
caused the regression.

Regards
Sebastian
