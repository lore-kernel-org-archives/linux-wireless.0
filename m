Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51536 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2KLTc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 14:32:56 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so4504689pad.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 11:32:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVPpivn=Z9F+552AueBptDU88hksQ0nzHkL7dWnx=d1M=w@mail.gmail.com>
References: <1352746052-1828-1-git-send-email-thomas@cozybit.com>
	<1352746052-1828-2-git-send-email-thomas@cozybit.com>
	<CAJ-VmokQ19oSgw6UB616n-7r2YZ7Udmtoh-20MPBYDfx3VPo+A@mail.gmail.com>
	<CAG6hwVPpivn=Z9F+552AueBptDU88hksQ0nzHkL7dWnx=d1M=w@mail.gmail.com>
Date: Mon, 12 Nov 2012 11:32:56 -0800
Message-ID: <CAJ-Vmok_fYed0FywJXkLcC2nMw6u50e8CfsgmZpvTSV3XnGxyA@mail.gmail.com> (sfid-20121112_203300_782188_9252BE5C)
Subject: Re: [PATCH 1/2] ath9k: RX timestamp is reported at end of frame
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: ath9k-devel@lists.ath9k.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 November 2012 11:26, Thomas Pedersen <thomas@cozybit.com> wrote:

> From our captures it looks like the entire aggragate gets the same
> timestamp (first frame?).

Right, so MACTIME_END is not appropriate there?



adrian
