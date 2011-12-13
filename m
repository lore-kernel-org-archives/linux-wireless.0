Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8807 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1LMNCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 08:02:51 -0500
Message-ID: <4EE74CF4.6090509@qca.qualcomm.com> (sfid-20111213_140255_323812_616983EE)
Date: Tue, 13 Dec 2011 15:02:44 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: cleanup ath6kl_priv()
References: <20111125111736.31760.12343.stgit@localhost6.localdomain6>
In-Reply-To: <20111125111736.31760.12343.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/2011 01:17 PM, Kalle Valo wrote:
> It really should not return a void pointer. Also remove useless casts
> from its users.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

Kalle
