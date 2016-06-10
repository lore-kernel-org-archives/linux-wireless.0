Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45292 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbcFJMdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 08:33:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wrightf <wright.feng@broadcom.com>
Subject: Re: [PATCH 3/6] brcmfmac: use ndev->needed_headroom to reserve additional header space
References: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
	<1464989472-29684-4-git-send-email-arend.vanspriel@broadcom.com>
Date: Fri, 10 Jun 2016 15:33:06 +0300
In-Reply-To: <1464989472-29684-4-git-send-email-arend.vanspriel@broadcom.com>
	(Arend van Spriel's message of "Fri, 3 Jun 2016 23:31:09 +0200")
Message-ID: <877fdxkyv1.fsf@purkki.adurom.net> (sfid-20160610_143336_267695_2D3BFF90)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> From: wrightf <wright.feng@broadcom.com>

Before I apply I'll fix this to:

From: Wright Feng <wright.feng@broadcom.com>

-- 
Kalle Valo
