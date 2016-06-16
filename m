Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57986 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbcFPPPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:15:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: b43: only hardcode LED behavior if SPROM doesn't encode any
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1464987843-6928-1-git-send-email-dev@lynxeye.de>
To: Lucas Stach <dev@lynxeye.de>
Cc: Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Message-Id: <20160616151505.C0EBD613FD@smtp.codeaurora.org> (sfid-20160616_171523_984341_0775227F)
Date: Thu, 16 Jun 2016 15:15:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lucas Stach <dev@lynxeye.de> wrote:
> Only hardcode the LED behavior if the SROM doesn't provide any for all
> LEDs of the card. This avoids instantiating LED triggers for unconnected
> LEDs, while (hopefully) keeping things working for old cards with a
> blank SROM.
> 
> Signed-off-by: Lucas Stach <dev@lynxeye.de>

Thanks, 1 patch applied to wireless-drivers-next.git:

508f1222ba4e b43: only hardcode LED behavior if SPROM doesn't encode any

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9154077/

