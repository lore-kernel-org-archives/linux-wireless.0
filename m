Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60071 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbcFNO1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 10:27:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: use kmemdup
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1463666357-16719-1-git-send-email-falakreyaz@gmail.com>
To: Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160614142709.29C84613EB@smtp.codeaurora.org> (sfid-20160614_162746_991212_F8C14BFF)
Date: Tue, 14 Jun 2016 14:27:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Muhammad Falak R Wani <falakreyaz@gmail.com> wrote:
> Use kmemdup when some other buffer is immediately copied into allocated
> region. It replaces call to allocation followed by memcpy, by a single
> call to kmemdup.
> 
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

d464fd8b48f3 brcmfmac: use kmemdup

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9127677/

