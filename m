Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:43702 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384Ab2FMTE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 15:04:26 -0400
Received: by lagw12 with SMTP id w12so694242lag.24
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 12:04:23 -0700 (PDT)
Message-ID: <1339614262.10534.63.camel@cumari.coelho.fi> (sfid-20120613_210430_102070_D0768AFE)
Subject: Re: [PATCH] wlcore: avoid using NET_IP_ALIGN for RX alignment
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Jun 2012 22:04:22 +0300
In-Reply-To: <1339426795-6526-1-git-send-email-eyal@wizery.com>
References: <1339426795-6526-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-11 at 17:59 +0300, Eyal Shapira wrote:
> NET_IP_ALIGN can be overriden on different architectures
> and therefore cannot be used in the RX path to account
> for the 2 bytes added for alignment (either by the FW
> in the case of 18xx or by the host for 12xx).
> Instead use an internal define.
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---

Applied and pushed, thanks!

--
Luca.

