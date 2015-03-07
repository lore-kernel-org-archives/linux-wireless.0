Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55861 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbbCGHuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 02:50:08 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: update MODULE_FIRMWARE definitions for QCA6174
References: <1424261797-9474-1-git-send-email-bartosz.markowski@tieto.com>
Date: Sat, 7 Mar 2015 09:49:59 +0200
In-Reply-To: <1424261797-9474-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 18 Feb 2015 13:16:37 +0100")
Message-ID: <87ioed1c2g.fsf@kamboji.qca.qualcomm.com> (sfid-20150307_085014_416723_C04BBC67)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> This has been missed while adding the QCA6174 support.
> As in the last time, without advertising the firmware files
> as needed (or optional) for ath10k, these won't be built into
> ram disk for instance.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
