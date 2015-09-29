Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34668 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbbI2Hbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 03:31:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: brcmfmac: Reset PCIE devices after recognition.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1440684846-17214-1-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Rafal Milecki <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150929073136.EF7A2140BC3@smtp.codeaurora.org> (sfid-20150929_093140_441622_722E1BAA)
Date: Tue, 29 Sep 2015 07:31:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Hante Meuleman <meuleman@broadcom.com>
> 
> When PCIE type devices are being FW reloaded without being properly
> reset then the device ends up in a locked state, requiring the
> device to be completely powered down. This patch adds a reset
> through watchdog at the moment the device (cores) has been
> recognized. This will solve warm reboot issues.
> 
> Cc: Rafal Milecki <zajec5@gmail.com>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
