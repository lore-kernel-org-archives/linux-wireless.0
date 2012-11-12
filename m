Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46184 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2KLTez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 14:34:55 -0500
Received: by mail-qa0-f46.google.com with SMTP id c11so703177qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 11:34:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmok_fYed0FywJXkLcC2nMw6u50e8CfsgmZpvTSV3XnGxyA@mail.gmail.com>
References: <1352746052-1828-1-git-send-email-thomas@cozybit.com>
 <1352746052-1828-2-git-send-email-thomas@cozybit.com> <CAJ-VmokQ19oSgw6UB616n-7r2YZ7Udmtoh-20MPBYDfx3VPo+A@mail.gmail.com>
 <CAG6hwVPpivn=Z9F+552AueBptDU88hksQ0nzHkL7dWnx=d1M=w@mail.gmail.com> <CAJ-Vmok_fYed0FywJXkLcC2nMw6u50e8CfsgmZpvTSV3XnGxyA@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 12 Nov 2012 11:34:34 -0800
Message-ID: <CAG6hwVNPysBy977fWC7knFV7ML64nFmNpaeiTEtsZSzKiKPF_Q@mail.gmail.com> (sfid-20121112_203458_853224_C7514DA5)
Subject: Re: [PATCH 1/2] ath9k: RX timestamp is reported at end of frame
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel@lists.ath9k.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 11:32 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 12 November 2012 11:26, Thomas Pedersen <thomas@cozybit.com> wrote:
>
>> From our captures it looks like the entire aggragate gets the same
>> timestamp (first frame?).
>
> Right, so MACTIME_END is not appropriate there?

I don't think it really matters since before they would also all get
the same timestamp anyway?

Thomas
