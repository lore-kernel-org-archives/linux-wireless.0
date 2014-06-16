Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57440 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbaFPJYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 05:24:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <wcn36xx@lists.infradead.org>
Subject: Re: [PATCH -next 13/26] ath: Use dma_zalloc_coherent
References: <cover.1402863904.git.joe@perches.com>
	<55b103a2ec78c0031b348e103603bf9a0d9cac3b.1402863905.git.joe@perches.com>
Date: Mon, 16 Jun 2014 12:24:46 +0300
In-Reply-To: <55b103a2ec78c0031b348e103603bf9a0d9cac3b.1402863905.git.joe@perches.com>
	(Joe Perches's message of "Sun, 15 Jun 2014 13:37:42 -0700")
Message-ID: <87fvj52om9.fsf@kamboji.qca.qualcomm.com> (sfid-20140616_112530_369402_79A7A02A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> Use the zeroing function instead of dma_alloc_coherent & memset(,0,)
>
> Signed-off-by: Joe Perches <joe@perches.com>

For ath10k:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
