Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41708 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbcASNFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 08:05:46 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: add missing include
References: <1452870030-56506-1-git-send-email-nbd@openwrt.org>
Date: Tue, 19 Jan 2016 15:05:40 +0200
In-Reply-To: <1452870030-56506-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Fri, 15 Jan 2016 16:00:30 +0100")
Message-ID: <87vb6p4t3v.fsf@kamboji.qca.qualcomm.com> (sfid-20160119_140551_109424_D6E58E0A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> linux/module.h is required for defining module parameters
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

I'm planning to send this to 4.5.

-- 
Kalle Valo
