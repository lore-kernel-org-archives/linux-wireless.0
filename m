Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49029 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbcAGJVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 04:21:30 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [V2,
 1/7] brcmfmac: add arp offload ip address table configuration support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1451724102-21911-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20160107092130.4460F605BD@smtp.codeaurora.org> (sfid-20160107_102141_236584_C54D72F1)
Date: Thu,  7 Jan 2016 09:21:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Franky Lin <frankyl@broadcom.com>
> 
> Obtain ipv4 address through inetaddr notification for ARP offload host
> ip table configuration.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 7 patches applied to wireless-drivers-next.git:

44129ed04b2b brcmfmac: add arp offload ip address table configuration support
3f5893d1b30a brcmfmac: Add get_station support for IBSS
48ed16e86b28 brcmfmac: Add support for scheduled scan mac randomization
ec64241c9fd2 brcmfmac: obtain feature info using 'cap' firmware command
6a98d64a27de brcmfmac: Fix warn trace on module unload while in ibss mode
7d34b0560567 brcmfmac: Move all module parameters to one place
8ba83d4daab9 brcmfmac: introduce module parameter to force successful probe

Kalle Valo
