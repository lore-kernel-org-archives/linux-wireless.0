Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39111 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbcGTS16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 14:27:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Reizer\, Eyal" <eyalr@ti.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-spi\@vger.kernel.org" <linux-spi@vger.kernel.org>,
	Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] wlcore: spi: fix build warning caused by redundant variable
References: <1468999637-31006-1-git-send-email-eyalr@ti.com>
	<8665E2433BC68541A24DFFCA87B70F5B36161A64@DFRE01.ent.ti.com>
Date: Wed, 20 Jul 2016 21:27:53 +0300
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B36161A64@DFRE01.ent.ti.com>
	(Eyal Reizer's message of "Wed, 20 Jul 2016 07:30:20 +0000")
Message-ID: <87wpkgqi52.fsf@kamboji.qca.qualcomm.com> (sfid-20160720_202830_351717_4B2317B5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Reizer, Eyal" <eyalr@ti.com> writes:

> The ret variable is unused in wlcore_probe_of()
> Remove it for fixing build warning.
>
> Fixes: 01efe65aba65 ("wlcore: spi: add wl18xx support")
> Signed-off-by: Eyal Reizer <eyalr@ti.com>

Applied to wireless-drivers-next, thanks.

-- 
Kalle Valo
