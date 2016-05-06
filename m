Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42757 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbcEFSJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 14:09:42 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"mohammed@codeaurora.org" <mohammed@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Move spectral related structures under ath10k
 debugfs
Date: Fri, 6 May 2016 18:09:35 +0000
Message-ID: <87eg9fnjmp.fsf@kamboji.qca.qualcomm.com> (sfid-20160506_200956_058060_3EAC4EF7)
References: <1461684276-4042-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1461684276-4042-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Tue, 26 Apr 2016 20:54:36	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> Spectral related structures are accessed / modified only if ath10k
> debugfs is enabled, so it makes more sense to move them under
> ATH10K_DEBUGFS
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo