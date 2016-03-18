Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62934 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbcCRH5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 03:57:43 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Kolli, Anilkumar" <akolli@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"akolli@codeaurora.org" <akolli@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix debugfs pktlog_filter write
Date: Fri, 18 Mar 2016 07:57:32 +0000
Message-ID: <8760wki5g4.fsf@kamboji.qca.qualcomm.com> (sfid-20160318_085756_108401_FDC55758)
References: <1457676999-32678-1-git-send-email-akolli@qti.qualcomm.com>
In-Reply-To: <1457676999-32678-1-git-send-email-akolli@qti.qualcomm.com>
	(akolli@qti.qualcomm.com's message of "Fri, 11 Mar 2016 11:46:39	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<akolli@qti.qualcomm.com> writes:

> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>
> It is observed that, we are disabling the packet log if we write same
> value to the pktlog_filter for the second time. Always enable pktlogs
> on non zero filter.
>
> Fixes: 90174455ae05 ("ath10k: add support to configure pktlog filter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo