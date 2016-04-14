Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47578 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbcDNNBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 09:01:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/8] brcmfmac: clear eventmask array before using it
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460367328-12082-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20160414130120.C084A60DB8@smtp.codeaurora.org> (sfid-20160414_150127_022254_06051D24)
Date: Thu, 14 Apr 2016 13:01:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Hante Meuleman <hante.meuleman@broadcom.com>
> 
> When the event_msgs iovar is set an array is used to configure the
> enabled events. This arrays needs to nulled before configuring
> otherwise unhandled events will be enabled. This solves a problem
> where in case of wowl the host got woken by an incorrectly enabled
> event.
> 
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 8 patches applied to wireless-drivers-next.git:

7fde010d473d brcmfmac: clear eventmask array before using it
28b285a6129d brcmfmac: fix clearing wowl wake indicators
46f2b38a91b0 brcmfmac: insert default boardrev in nvram data if missing
2aec2c9d42aa brcmfmac: fix p2p scan abort null pointer exception
c56caa9db8ab brcmfmac: screening firmware event packet
bbd1f932e7c4 brcmfmac: cleanup ampdu-rx host reorder code
9c349892ccc9 brcmfmac: revise handling events in receive path
c462ebcdfe42 brcmfmac: create common function for handling brcmf_proto_hdrpull()

Kalle Valo
