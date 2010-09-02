Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.netsonic.fi ([194.29.192.26]:39725 "EHLO smtp.netsonic.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab0IBU4g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 16:56:36 -0400
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: Michael Trimarchi <michael@panicking.kicks-ass.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 0/1] ath6kl: add ath6kl driver for AR6003 chip
References: <1283381473-20415-1-git-send-email-vmehta@atheros.com>
	<87tym8vdio.fsf@macbook.be.48ers.dk>
	<4C7F74A4.1080706@panicking.kicks-ass.org>
	<84hbi82zwm.fsf@sauna.l.org>
	<35B17FE5076C7040809188FBE7913F983F234795E4@SC1EXMB-MBCL.global.atheros.com>
From: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Date: Thu, 02 Sep 2010 23:52:46 +0300
In-Reply-To: <35B17FE5076C7040809188FBE7913F983F234795E4@SC1EXMB-MBCL.global.atheros.com> (Vipin Mehta's message of "Thu\, 2 Sep 2010 11\:12\:54 -0700")
Message-ID: <84aanzzx41.fsf@sauna.l.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vipin Mehta <Vipin.Mehta@Atheros.com> writes:
>    Has this issue been already addressed with the version of the
>    driver on which it was found? If yes, then we should try to get

No. I just reported it and wasn't capable enough to figure out how to
check privileges of the caller properly.
