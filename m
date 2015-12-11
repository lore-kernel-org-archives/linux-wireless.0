Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43631 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbbLKLyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 06:54:08 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [V2,01/13] brcmfmac: Simplify scan timing configuration
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1449751392-32569-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20151211115407.EF134141DCC@smtp.codeaurora.org> (sfid-20151211_125418_290386_05EBA605)
Date: Fri, 11 Dec 2015 11:54:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Hante Meuleman <meuleman@broadcom.com>
> 
> No need to pass timing configuration in local functions as they are
> static anyway.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 12 patches applied to wireless-drivers-next.git:

1678ba8ed350 brcmfmac: Simplify scan timing configuration
675f5d82a73f brcmfmac: Use local storage for ssid iovar
4235edcdfc30 brcmfmac: Remove some redundant cfg80211 data
6c404f34f2bd brcmfmac: Cleanup pmksa cache handling code
a7b82d474171 brcmfmac: Make TDLS a detectable feature
fdf345642297 brcmfmac: Add support for PCIE 4350 revision 5 device
353c46ac9e53 brcmfmac: no interface combination check for single interface
b0a790883ed4 brcmfmac: Fix IBSS setup
a7decc44a002 brcmfmac: fix waitqueue_active without memory barrier in brcmfmac driver
540313d8f954 brcmfmac: add 43242 device id for LG dongle
f3fb75038dd1 brcmfmac: Change error print in debug print
a41286aee42f brcmfmac: Move scheduled scan related interface layer structs

Kalle Valo
