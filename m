Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52218 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbbEINb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 09:31:56 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] bcma: use absolute base for SoC GPIO pins
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1429103273-89272-1-git-send-email-nbd@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com, hauke@hauke-m.de
Message-Id: <20150509133155.9A7CE14004A@smtp.codeaurora.org> (sfid-20150509_153201_567684_08FAFC80)
Date: Sat,  9 May 2015 13:31:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On some BCM5301x ARM devices, user space still needs to control some
> system GPIO pins for which no driver exists. This is a lot easier to do
> with a predictable GPIO base.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, 2 patches applied to wireless-drivers-next.git:

2d57b7126d6d bcma: use absolute base for SoC GPIO pins
f022ea52d9a5 bcma: enable 32 GPIO pins for BCM4707

Kalle Valo
