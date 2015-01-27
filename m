Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44748 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbA0OU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 09:20:29 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix dtim period with beacon templates
References: <1421417336-19371-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Jan 2015 16:19:59 +0200
In-Reply-To: <1421417336-19371-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 16 Jan 2015 15:08:56 +0100")
Message-ID: <87mw54b90w.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_152032_238672_4F19FF34)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Firmware supporting beacon templates (i.e. wmi-tlv
> for qca6174) doesn't implicitly take dtim period
> from the template. Instead it requires vdev param
> to be set accordingly.
>
> This fixes dtim period being stuck at 3.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
