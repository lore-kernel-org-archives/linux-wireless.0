Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54546 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbbAZNjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 08:39:03 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 07/10] wil6210: remove unnecessary interrupt moderation module parameters
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1422175971-8075-8-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Mon, 26 Jan 2015 15:38:57 +0200
In-Reply-To: <1422175971-8075-8-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Sun, 25 Jan 2015 10:52:48 +0200")
Message-ID: <87fvaxfyq6.fsf@kamboji.qca.qualcomm.com> (sfid-20150126_143907_991008_481E3485)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> From: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>
>
> Interrupt moderation parameters will never be passed as module
> parameters. For product, they will be hard-coded after lab testing,
> and for debugging, they can be altered via debugfs.
>
> Signed-off-by: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Perfect, thanks for doing this.

-- 
Kalle Valo
