Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35244 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab1JCKsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 06:48:39 -0400
Message-ID: <4E899301.8040808@qca.qualcomm.com> (sfid-20111003_124844_736937_AB1CC693)
Date: Mon, 3 Oct 2011 13:48:33 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next] drivers/net: Add module.h to wireless/ath/ath6kl/sdio.c
References: <1317424079-31793-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1317424079-31793-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/01/2011 02:07 AM, Paul Gortmaker wrote:
> This file uses various MODULE_* macros, and so needs the full
> module.h header called out explicitly.

FWIW last week I added a similar patch to ath6kl.git (but not the same
as the file has changed):

https://github.com/kvalo/ath6kl/commit/c6efe578fc5dd02463d2ee20343494da56bdd3a9

I also sent a pull request to John so it should be in wireless-next soon.

Kalle
