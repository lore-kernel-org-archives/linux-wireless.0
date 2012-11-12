Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54887 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2KLT0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 14:26:34 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so3981707qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 11:26:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmokQ19oSgw6UB616n-7r2YZ7Udmtoh-20MPBYDfx3VPo+A@mail.gmail.com>
References: <1352746052-1828-1-git-send-email-thomas@cozybit.com>
 <1352746052-1828-2-git-send-email-thomas@cozybit.com> <CAJ-VmokQ19oSgw6UB616n-7r2YZ7Udmtoh-20MPBYDfx3VPo+A@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 12 Nov 2012 11:26:13 -0800
Message-ID: <CAG6hwVPpivn=Z9F+552AueBptDU88hksQ0nzHkL7dWnx=d1M=w@mail.gmail.com> (sfid-20121112_202638_055644_8B945E6F)
Subject: Re: [PATCH 1/2] ath9k: RX timestamp is reported at end of frame
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel@lists.ath9k.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 11:18 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> Hi,
>
> Is that true for aggregate RX too? I didn't think the FIFO was big
> enough to receive the whole aggregate, so I wonder what timestamp
> aggregates sub-frames are receiving.

>From our captures it looks like the entire aggragate gets the same
timestamp (first frame?).

Thomas
