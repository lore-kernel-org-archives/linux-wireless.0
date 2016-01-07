Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34734 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbcAGNBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 08:01:50 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH v1 0/2] wil6210 patches
References: <1450281106-29416-1-git-send-email-qca_merez@qca.qualcomm.com>
Date: Thu, 07 Jan 2016 15:01:43 +0200
In-Reply-To: <1450281106-29416-1-git-send-email-qca_merez@qca.qualcomm.com>
	(Maya Erez's message of "Wed, 16 Dec 2015 17:51:44 +0200")
Message-ID: <8760z5lf0o.fsf@kamboji.qca.qualcomm.com> (sfid-20160107_140153_632544_2C8236E7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> Chanes in V1:
> - Fixed patches author and sign-off.
>
> Those patches fix wil6210 issue and add support for platform specific recovery after FW crash
>
> Hamad Kadmany (1):
>   wil6210: fix kernel OOPS when stopping interface during Rx traffic
>
> Lior David (1):
>   wil6210: support for platform specific crash recovery

Applied to ath.git, thanks.

-- 
Kalle Valo
