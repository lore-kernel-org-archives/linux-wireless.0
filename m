Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42087 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965380AbcA1IYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 03:24:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: Drop useless const on chanctx_event_delta() return type
References: <1452865290-32314-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 28 Jan 2016 10:24:14 +0200
In-Reply-To: <1452865290-32314-1-git-send-email-geert@linux-m68k.org> (Geert
	Uytterhoeven's message of "Fri, 15 Jan 2016 14:41:30 +0100")
Message-ID: <87fuxim7rl.fsf@kamboji.qca.qualcomm.com> (sfid-20160128_092443_002929_B0445F6A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> drivers/net/wireless/ath/ath9k/channel.c:230: warning: type qualifiers ignored on function return type
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied to ath.git, thanks.

-- 
Kalle Valo
