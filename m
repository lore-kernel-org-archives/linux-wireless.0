Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.netsonic.fi ([194.29.192.26]:45812 "EHLO smtp.netsonic.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab0IBLEg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 07:04:36 -0400
To: Michael Trimarchi <michael@panicking.kicks-ass.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
	Vipin Mehta <vmehta@atheros.com>,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	devel@linuxdriverproject.org
Subject: Re: [PATCH 0/1] ath6kl: add ath6kl driver for AR6003 chip
References: <1283381473-20415-1-git-send-email-vmehta@atheros.com>
	<87tym8vdio.fsf@macbook.be.48ers.dk>
	<4C7F74A4.1080706@panicking.kicks-ass.org>
From: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Date: Thu, 02 Sep 2010 13:38:49 +0300
In-Reply-To: <4C7F74A4.1080706@panicking.kicks-ass.org> (Michael Trimarchi's message of "Thu\, 02 Sep 2010 11\:55\:48 +0200")
Message-ID: <84hbi82zwm.fsf@sauna.l.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Trimarchi <michael@panicking.kicks-ass.org> writes:
> Looking at the code I think that is basically the same.

Does it then also suffer from the bug where a non-root user can
sabotage your network connectivity by periodically disabling
power_mode MAX_PERF_POWER? I'm not a kernel hacker but I could not see
anything checking for root or CAP_NET_ADMIN in the proposed driver.

The bug report for the git.openmoko.org branch is at
http://docs.openmoko.org/trac/ticket/2321
