Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:20545 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbbJMMzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 08:55:01 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix cleanup in ath10k_thermal_unregister
References: <1444300383-9645-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Tue, 13 Oct 2015 15:54:48 +0300
In-Reply-To: <1444300383-9645-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Thu, 8 Oct 2015 16:03:03
	+0530")
Message-ID: <87mvvnormv.fsf@kamboji.qca.qualcomm.com> (sfid-20151013_145506_300999_C7FF8DA0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> First remove the 'cooling_device#n' syslink created
> for ath10k and then unregsiter from the thermal subsystem(cooling)
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
