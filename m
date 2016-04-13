Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27682 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbcDMJOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 05:14:51 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH v2] ath10k: remove MSI range support
Date: Wed, 13 Apr 2016 09:14:17 +0000
Message-ID: <87a8kxuaza.fsf@kamboji.qca.qualcomm.com> (sfid-20160413_111456_107654_65A823C7)
References: <1460011258-15893-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1460011258-15893-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Thu, 7 Apr 2016 12:10:58 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> MSI-X is never well-tested, might contain bugs and generally isn't
> really all that useful to maintain. Also ath10k is mainly used with
> shared/singly-MSI interrupt systems. Hence removing MSI range support.
> This change will be useful for further cleanup in copy engine lock
> and to add NAPI support.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo