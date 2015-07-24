Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34176 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbGXOW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 10:22:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
Subject: Re: [PATCH v2 02/13] wil6210: ACS implementation using QCA vendor command
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1436168389-3676-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1436168389-3676-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Fri, 24 Jul 2015 17:22:18 +0300
In-Reply-To: <1436168389-3676-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Mon, 6 Jul 2015 10:39:38 +0300")
Message-ID: <878ua5eiud.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_162230_277290_7EAA1BD8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> ACS is implemented by registering to QCA vendor ACS sub command.
> On receive of the command from hostapd, driver issues passive
> scan command and block until scan results are available.
> When received, the results are sent up using QCA vendor ACS
> results event
>
> Signed-off-by: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

I dropped this patch per discussion but now I got a conflict:

Pushing patch "wil6210-improve-mgmt-frame-han" ... done (conflict)
Error: 1 merge conflict(s)
       CONFLICT (content): Merge conflict in
       drivers/net/wireless/ath/wil6210/wmi.c

Please resend the whole patchset.

-- 
Kalle Valo
