Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44183 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab2E3SsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 14:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <1338394222-10274-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1338394222-10274-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Wed, 30 May 2012 11:48:21 -0700
Message-ID: <CAJ-VmomiQjGKKPtErYuhChpvqHCof4wXwt4BH2n1Rei_RnvyGA@mail.gmail.com> (sfid-20120530_204826_318266_4EEF3727)
Subject: Re: [RFC] ath9k: Fix softlockup in AR9485
From: Adrian Chadd <adrian@freebsd.org>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Yes, this is a public response.)

Hi,

That has me a bit concerned. Waiting for the STA to be associated is
really just some kind of "settling" delay. You're still TX/RXing at
that point.

I think we need to speak to the baseband/clock teams and figure out
why this is actually occuring.

Can we please leave this out of the tree (but in the bug report) until
this gets root caused internally?

Thanks,



adrian
