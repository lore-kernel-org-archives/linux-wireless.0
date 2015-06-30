Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38195 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbbF3MhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 08:37:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Dedy Lansky <qca_dlansky@qualcomm.com>,
	Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>
Subject: Re: [PATCH] wil6210: restart AP upon change in privacy settings
References: <1434379352-14084-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Tue, 30 Jun 2015 15:37:00 +0300
In-Reply-To: <1434379352-14084-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Mon, 15 Jun 2015 17:42:32 +0300")
Message-ID: <87lhf11ifn.fsf@kamboji.qca.qualcomm.com> (sfid-20150630_143925_012113_CEB0D486)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> privacy settings might change while AP is running.
> Inside wil_cfg80211_change_beacon(), detect change
> in privacy settings and handle it by stopping and
> re-starting the AP.
> Firmware cannot handle on-the-fly privacy settings
> change and so AP restart is required.
>
> Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
> Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
