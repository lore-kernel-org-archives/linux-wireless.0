Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:51608 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaATGtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 01:49:53 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21212.50632.546135.912658@gargle.gargle.HOWL> (sfid-20140120_074956_757615_4D54D407)
Date: Mon, 20 Jan 2014 12:14:24 +0530
To: Alex Hacker <hacker@epn.ru>
Cc: John Linville <linville@tuxdriver.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix IQ calibration
In-Reply-To: <20140120060204.GB5929@infinet.ru>
References: <1389686117-9014-1-git-send-email-sujith@msujith.org>
	<20140120060204.GB5929@infinet.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alex Hacker wrote:
> While the 'i2_p_q2_a0_d1 = (iq_res[2] & 0xfff)' the condition
> 'i2_p_q2_a0_d1 > 0x1000' is always false.

You are correct. I'll check with the systems engineers if something else
is missing. Thanks !

Sujith
