Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58440 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab1JAKST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 06:18:19 -0400
Message-ID: <4E86E8B5.3080804@qca.qualcomm.com> (sfid-20111001_121823_167347_3FA20CF5)
Date: Sat, 1 Oct 2011 13:17:25 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix size_t related warnings
References: <20111001065201.25817.35530.stgit@localhost6.localdomain6>
In-Reply-To: <20111001065201.25817.35530.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/01/2011 09:52 AM, Kalle Valo wrote:
> My earlier debug log additions added these warnings when compiling 64 bit
> kernels:
> 
> ath6kl/init.c:962: warning: format ‘%d’ expects type ‘int’,
>   but argument 3 has type ‘size_t’
> ath6kl/init.c:975: warning: format ‘%d’ expects type ‘int’,
>   but argument 3 has type ‘size_t’
> ath6kl/init.c:988: warning: format ‘%d’ expects type ‘int’,
>   but argument 3 has type ‘size_t’
> ath6kl/init.c:1009: warning: format ‘%d’ expects type ‘int’,
>   but argument 3 has type ‘size_t’
> ath6kl/init.c:1192: warning: format ‘%d’ expects type ‘int’,
>   but argument 4 has type ‘size_t’
> ath6kl/init.c:1236: warning: format ‘%d’ expects type ‘int’,
>   but argument 4 has type ‘size_t’
> ath6kl/init.c:1267: warning: format ‘%d’ expects type ‘int’,
>   but argument 4 has type ‘size_t’

Applied.

Kalle
