Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57682 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbbGVGHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 02:07:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the wireless-drivers-next tree
References: <20150722103239.04995fda@canb.auug.org.au>
Date: Wed, 22 Jul 2015 09:07:05 +0300
In-Reply-To: <20150722103239.04995fda@canb.auug.org.au> (Stephen Rothwell's
	message of "Wed, 22 Jul 2015 10:32:39 +1000")
Message-ID: <871tg0n2t2.fsf@kamboji.qca.qualcomm.com> (sfid-20150722_080738_302862_A0BA3E0D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stephen,

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> After merging the wireless-drivers-next tree, today's linux-next build
> (x86_64 allmodconfig) failed like this:
>
> ERROR: "of_default_bus_match_table" [drivers/bcma/bcma.ko] undefined!
>
> Caused by commit
>
>   cae761b5a6bd ("bcma: populate bus DT subnodes as platform_device-s")
>
> I have used the wireless-drivers-next tree from next-20150721 for today.

Sorry about that.

Rafal, can you please send a patch to fix this? I'll apply it ASAP.

-- 
Kalle Valo
