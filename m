Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41976 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933124AbcKWT0t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 14:26:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-wireless@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: ath9k ARMv7 OOPS in v4.8.6, v4.2.8
References: <20161123191539.GF2799@io.lakedaemon.net>
Date: Wed, 23 Nov 2016 21:26:42 +0200
In-Reply-To: <20161123191539.GF2799@io.lakedaemon.net> (Jason Cooper's message
        of "Wed, 23 Nov 2016 19:15:39 +0000")
Message-ID: <87a8cqgfpp.fsf@kamboji.qca.qualcomm.com> (sfid-20161123_202653_424565_6F2A8A43)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Cooper <jason@lakedaemon.net> writes:

> All,
>
> I have a Ubiquiti SR-71 mini-pcie ath9k card in a Globalscale Mirabox
> board (Marvell Armada 370 SoC).  Every day or so I get a consistent
> crash that brings down the whole board.  I've attached three oops I
> captured on the serial port.
>
> I looked at the commits from v4.8.6 to v4.9-rc6, and nothing jumped out
> at me as "this would fix it".  And since it takes a day or so to trigger
> the oops, bisecting would be a bit brutal.  Does anyone have any insight
> into this?

Is this a regression, meaning that it didn't crash on older kernels but
crashes on newer ones? Or has it always crashed?

-- 
Kalle Valo
