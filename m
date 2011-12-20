Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33044 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1LTStu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 13:49:50 -0500
Received: by iaeh11 with SMTP id h11so10625412iae.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 10:49:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324406771-7100-2-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com> <1324406771-7100-2-git-send-email-rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 20 Dec 2011 10:49:29 -0800
Message-ID: <CAB=NE6XLwBsBDTM_q1medLUQAsixs=+nY4CcsstcfmNXdGSqWg@mail.gmail.com> (sfid-20111220_195000_700656_1DE2B862)
Subject: Re: [PATCH 1/6] ath6kl: fix sparse warning on init.c
To: linville@tuxdriver.com, Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 20, 2011 at 10:46 AM, Luis R. Rodriguez
<rodrigue@qca.qualcomm.com> wrote:
> From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
>
> This fixes this sparse warning:
>
>  CC [M]  drivers/net/wireless/ath/ath6kl/init.o
> drivers/net/wireless/ath/ath6kl/init.c: In function ‘ath6kl_init_hw_params’:
> drivers/net/wireless/ath/ath6kl/init.c:1377:26: warning: ‘hw’ may be used uninitialized in this function
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Not sure if Kalle will suck this in or if John will.

  Luis
