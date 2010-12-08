Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51310 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab0LHCEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 21:04:35 -0500
Received: by pwj3 with SMTP id 3so166547pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 18:04:35 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19710.59280.252769.952190@gargle.gargle.HOWL>
Date: Wed, 8 Dec 2010 07:34:00 +0530
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Sujith <m.sujith@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
In-Reply-To: <20101207194646.GG2700@tuxdriver.com>
References: <19701.62091.644444.121284@gargle.gargle.HOWL>
	<20101202193024.GC2358@tuxdriver.com>
	<19704.23185.565826.890275@gargle.gargle.HOWL>
	<AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
	<19709.45926.38551.25130@gargle.gargle.HOWL>
	<20101207194646.GG2700@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Obviously I didn't overlook it, or I wouldn't have asked about whether
> or not it should go to 2.6.37...

Sorry, I saw the other patch [1/2] merged and thought that you missed this.

> > Applying 4/5 and 5/5 from your series seems to fix the issue though.
> > I am able to suspend/resume without hiccups with UB95.
> 
> But now this begs the question of whether this should be applied at all?

Yes, this is needed for ath9k_htc.

Sujith
