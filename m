Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40859 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbcGRTnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:43:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: allow enabling serial flash support on non-MIPS SoCs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1468838054-17014-1-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-kernel@vger.kernel.org (open list)
Message-Id: <20160718194350.00DA46029F@smtp.codeaurora.org> (sfid-20160718_214358_340289_32F98BC1)
Date: Mon, 18 Jul 2016 19:43:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> So far we had only MIPS devices with serial flash connected to the SoC's
> ChipCommon. ARM devices got a separated SPI controller and weere using
> standard SPI drivers.
> This has changed with the wireless SoC BCM47189B0. It's ARM based but
> has serial flash attached just like older devices. This allows using
> existing driver with these devices.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

57d8f7dd2132 bcma: allow enabling serial flash support on non-MIPS SoCs

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9234387/

