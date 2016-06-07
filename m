Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22435 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609AbcFGPTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 11:19:24 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: David Binderman <linuxdev.baldrick@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dcb314@hotmail.com" <dcb314@hotmail.com>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>
Subject: Re: linux-4.7-rc2/drivers/net/wireless/ath/ath6kl/wmi.c:2547]:
 (style) Redundant condition
Date: Tue, 7 Jun 2016 15:19:16 +0000
Message-ID: <87inxlni19.fsf@kamboji.qca.qualcomm.com> (sfid-20160607_172001_433616_914D6297)
References: <CAMzoamY2uhXDsLsE2o8mCF923XXWoGp3oF_AMmVnDY=EuachZA@mail.gmail.com>
In-Reply-To: <CAMzoamY2uhXDsLsE2o8mCF923XXWoGp3oF_AMmVnDY=EuachZA@mail.gmail.com>	(David
 Binderman's message of "Tue, 7 Jun 2016 16:13:48 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Binderman <linuxdev.baldrick@gmail.com> writes:

> Hello there,
>
> linux-4.7-rc2/drivers/net/wireless/ath/ath6kl/wmi.c:2547]: (style)
> Redundant condition: If 'EXPR <= 7', the comparison 'EXPR < 8' is
> always true.
>
> Source code is
>
>     if (!((params->user_pri < 8) &&
>           (params->user_pri <= 0x7) &&
>
> This might be a possible cut'n'paste error.

This should be recently fixed:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=93b4a09f0f3068e3190548393f39262e5295960e

> Also in the same file
>
> [drivers/net/wireless/ath/ath6kl/wmi.c:1220]: (style) Variable 'rate'
> is assigned a value that is never used.
> [drivers/net/wireless/ath/ath6kl/wmi.c:1484]: (style) Variable
> 'new_threshold' is assigned a value that is never used.
> [drivers/net/wireless/ath/ath6kl/wmi.c:3521]: (style) Variable 'ret'
> is assigned a value that is never used.

I guess these are still valid.

-- 
Kalle Valo