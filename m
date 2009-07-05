Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1620 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbZGELy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 07:54:27 -0400
Date: Sun, 5 Jul 2009 07:53:23 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 4/5] ath5k: do not release irq across suspend/resume
Message-ID: <20090705115323.GC2132@hash.localnet>
References: <1246726795-3934-1-git-send-email-me@bobcopeland.com> <1246726795-3934-5-git-send-email-me@bobcopeland.com> <4A4FC889.9000401@gmail.com> <200907042337.59470.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200907042337.59470.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 04, 2009 at 11:37:58PM +0200, Rafael J. Wysocki wrote:
> Someone recently asked on a mailing list (unfortunately I can't recall
> which one) if drivers should release irqs over suspend.

Yeah, it was linux-wireless.  Original message is here:

http://marc.info/?l=linux-wireless&m=124515641807355

(The paraphrasing is rather liberal but that was the gist.)
-- 
Bob Copeland %% www.bobcopeland.com

