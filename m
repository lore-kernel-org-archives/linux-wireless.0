Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39397 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbcF2PpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:45:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] rtl8xxxu: Add bit definitions for REG_USB_SPECIAL_OPTION
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1465497530-18510-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160629154449.57F10613A4@smtp.codeaurora.org> (sfid-20160629_174614_126692_CC64D1E7)
Date: Wed, 29 Jun 2016 15:44:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Documentation for enabling USB aggregation and whether to select
> interrupt or bulk delivery of interrupt events.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

e4ac0a8ac8ba rtl8xxxu: Add bit definitions for REG_USB_SPECIAL_OPTION
08eca32ebc89 rtl8xxxu: Add additional documentation for RX DMA registers
2b9c9f52dc03 rtl8xxxu: tuse %*ph to dump buffers

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9167727/

