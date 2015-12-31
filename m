Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35618 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbbLaIaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 03:30:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Geliang Tang <geliangtang@163.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] ipw2x00: sdhci-pci: use to_pci_dev()
References: <baf4e17c993f197cc31f8a0e5736ee8a558ba44c.1451211133.git.geliangtang@163.com>
	<baf4e17c993f197cc31f8a0e5736ee8a558ba44c.1451211133.git.geliangtang@163.com>
	<896b7d080610c5417a2f09a3bf9d0e20636fcc52.1451211133.git.geliangtang@163.com>
Date: Thu, 31 Dec 2015 10:30:12 +0200
In-Reply-To: <896b7d080610c5417a2f09a3bf9d0e20636fcc52.1451211133.git.geliangtang@163.com>
	(Geliang Tang's message of "Sun, 27 Dec 2015 18:46:01 +0800")
Message-ID: <87r3i3nhpn.fsf@kamboji.qca.qualcomm.com> (sfid-20151231_093025_140172_32D5D30A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geliang Tang <geliangtang@163.com> writes:

> Use to_pci_dev() instead of open-coding it.
>
> Signed-off-by: Geliang Tang <geliangtang@163.com>

The title is wrong, it should be just "ipw2x00: use to_pci_dev()".

And please state clearly to what tree you are planning to submit these.
I only saw this patch 5, not rest of the patches, so I have no clue
what's going to happen with this patchset. Please resend.

-- 
Kalle Valo
