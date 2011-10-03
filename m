Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5793 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab1JCK4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 06:56:45 -0400
Message-ID: <4E899492.3090809@qca.qualcomm.com> (sfid-20111003_125650_077793_3A690390)
Date: Mon, 3 Oct 2011 13:55:14 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: include vmalloc.h in debug.c
References: <20111003104440.27129.60479.stgit@localhost6.localdomain6>
In-Reply-To: <20111003104440.27129.60479.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2011 01:44 PM, Kalle Valo wrote:
> Fixes compilation errors when compiling for ARM:
> 
> ath6kl/debug.c:312: error: implicit declaration of function 'vmalloc'
> ath6kl/debug.c:312: warning: assignment makes pointer from integer without a cast
> ath6kl/debug.c:342: error: implicit declaration of function 'vfree'
> ath6kl/debug.c:696: warning: assignment makes pointer from integer without a cast
> ath6kl/debug.c:871: warning: assignment makes pointer from integer without a cast

Applied.

Kalle
