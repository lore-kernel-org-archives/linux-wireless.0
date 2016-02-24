Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36317 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375AbcBXNuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 08:50:15 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 0/4] wil6210 bug fixes and performance enhancement
References: <1454001845-28414-1-git-send-email-qca_merez@qca.qualcomm.com>
Date: Wed, 24 Feb 2016 15:50:08 +0200
In-Reply-To: <1454001845-28414-1-git-send-email-qca_merez@qca.qualcomm.com>
	(Maya Erez's message of "Thu, 28 Jan 2016 19:24:01 +0200")
Message-ID: <87oab6i5f3.fsf@kamboji.qca.qualcomm.com> (sfid-20160224_145024_567341_332AA8CE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> The below patches include:
> - Bug fixes seen in stress connect/disconnect tests
> - Increasing the TX vring size for performance boost
>
> Hamad Kadmany (1):
>   wil6210: TX vring optimization
>
> Maya Erez (2):
>   wil6210: prevent access to vring_tx_data lock during its init
>   wil6210: protect synchronous wmi commands handling
>
> Vladimir Kondratiev (1):
>   wil6210: wait for disconnect completion

Applied to ath.git, thanks.

-- 
Kalle Valo
