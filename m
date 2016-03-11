Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37671 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbcCKMQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 07:16:50 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 00/13] disable hw peak cal for all ar9300 chips
Date: Fri, 11 Mar 2016 12:16:45 +0000
Message-ID: <874mcdnr9v.fsf@kamboji.qca.qualcomm.com> (sfid-20160311_131653_220073_1D94E58A)
References: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
In-Reply-To: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
	(miaoqing@codeaurora.org's message of "Fri, 26 Feb 2016 16:08:30	+0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@codeaurora.org writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> HW peak detect calibration would fail for AR9300 chips and
> we went for implementing the SW way of doing it instead of
> HW doing the peak detect calibration.
>
> Miaoqing Pan (13):
>   ath9k: Update QCA953x initvals
>   ath9k: Update AR9003 2.2 initvals
>   ath9k: Update AR933x initvals
>   ath9k: Update AR9340 initvals
>   ath9k: Update AR9462 initvals
>   ath9k: Update AR9485 initvals
>   ath9k: Update AR955x initvals
>   ath9k: Update AR9565 initvals
>   ath9k: Update QCA956x initvals
>   ath9k: Update AR9580 initvals
>   ath9k: enable manual peak cal for all ar9300 chips
>   ath9k: use AR_SREV_9003_PCOEM to identify PCOEM chips
>   ath9k: set correct peak detect threshold

Applied to ath.git, thanks.

-- 
Kalle Valo