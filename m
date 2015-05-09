Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53594 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbEIOVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 10:21:37 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/10] brcmfmac: device support and fixes
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
Date: Sat, 09 May 2015 17:21:30 +0300
In-Reply-To: <1429035033-14076-1-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Tue, 14 Apr 2015 20:10:23 +0200")
Message-ID: <87oaltltlh.fsf@kamboji.qca.qualcomm.com> (sfid-20150509_162913_577498_03DCE491)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Arend van Spriel <arend@broadcom.com> writes:

> This series include some fixes related to SDIO suspend and resume,
> wiphy band info and changes in regulatory settings. Furthermore,
> support for BCM4324 SDIO and BCM4358 PCIe is added. Finally,
> some patches from Hante that should enable support of PCIe devices
> on router platforms.

Your patch series are always top notch but I still would like to ask for
one small formatting change :) It would make my life easier if you could
list the major changes like this:

* SDIO suspend and resume fixes
* wiphy band info and changes in regulatory settings
* add support for BCM4324 SDIO and BCM4358 PCIe
* enable support of PCIe devices on router platforms (Hante)

That way I could directly copy your list to the pull request I send to
Dave.

-- 
Kalle Valo
