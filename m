Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58725 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbbBZNOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 08:14:54 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/6] brcmfmac: use helper function for changing SDIO state
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423244207-9707-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150226131453.AE3F314083D@smtp.codeaurora.org> (sfid-20150226_141457_266376_1106FD26)
Date: Thu, 26 Feb 2015 13:14:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Changing the SDIO state of the driver involves changing the bus
> interface state. Adding a helper function makes sure that knowledge
> is in one place.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 6 patches applied to wireless-drivers-next.git:

a1ce7a0d6a4f brcmfmac: use helper function for changing SDIO state
ad5a52518aa5 brcmfmac: Remove error print for invalid key index.
c7cd5d27d848 brcmfmac: add debugfs file containing revision info
9982464379e8 brcmfmac: make sdio suspend wait for threads to freeze
a7b134a7676e brcmfmac: Dont sleep when ctrl frames to transmit.
661fa95ddb9e brcmfmac: Fix escan timer causing oops.

Kalle Valo
