Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52889 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbbFOJvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 05:51:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mt7601u: don't warn about devices without per-rate power table
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433959809-919-1-git-send-email-moorray3@wp.pl>
To: Jakub Kici?ski <moorray3@wp.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Message-Id: <20150615095142.D678C1409E8@smtp.codeaurora.org> (sfid-20150615_115146_877820_FDA3C5B6)
Date: Mon, 15 Jun 2015 09:51:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jakub Kicinski <kubakici@wp.pl>
> 
> We expect EEPROM per-rate power table to be filled with
> s6 values and warn user if values are invalid.  However,
> there appear to be devices which don't have this section
> of EEPROM initialized.  In such case we should ignore
> the values and leave the driver power tables set to zero.
> 
> Note that vendor driver doesn't care about this case but
> mt76x2 skips 0xff per value.  We take mt76x2's approach.
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

Thanks, applied to wireless-drivers-next.git. And your name looked correct in
git log even though I used patchwork to apply your patch.

Kalle Valo
