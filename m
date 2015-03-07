Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58603 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbbCGIyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 03:54:03 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: brcmfmac: Perform bound checking on vendor command buffer
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1425655123-18916-1-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Pontus Fuchs <pontusf@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150307085402.A940913FC94@smtp.codeaurora.org> (sfid-20150307_095414_612467_DB114AA8)
Date: Sat,  7 Mar 2015 08:54:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Pontus Fuchs <pontusf@broadcom.com>
> 
> A short or malformed vendor command buffer could cause reads outside
> the command buffer.
> 
> Cc: stable@vger.kernel.org # v3.19
> Signed-off-by: Pontus Fuchs <pontusf@broadcom.com>
> [arend@broadcom.com: slightly modified debug trace output]
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, applied to wireless-drivers.git.

Kalle Valo
