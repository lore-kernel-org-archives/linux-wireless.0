Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23235 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaKZGlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 01:41:16 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] ath10k: firmware memory debugfs interface
References: <20141125102302.3951.10641.stgit@potku.adurom.net>
Date: Wed, 26 Nov 2014 08:40:58 +0200
In-Reply-To: <20141125102302.3951.10641.stgit@potku.adurom.net> (Kalle Valo's
	message of "Tue, 25 Nov 2014 12:24:23 +0200")
Message-ID: <87h9xmxy4l.fsf@kamboji.qca.qualcomm.com> (sfid-20141126_074119_128527_FB0A9171)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> this is v3 of Yanbo's firmware memory debugfs interface.
>
> Changelog:
>
> v3:
>
> * check ath10k state and return an error if firmware is not running
>
> * switch to use conf_mutex because using ar->state
>
> * fix copy_from_user() error handling
>
> v2:
>
> * split patches into two
>
> * simplify the commit logs
>
> * remove extra #include "hif.h" from debug.c
>
> ---
>
> Yanbo Li (2):
>       ath10k: add register access debugfs interface
>       ath10k: add memory dump debugfs interface

Thanks Yanbo, both patches applied.

-- 
Kalle Valo
