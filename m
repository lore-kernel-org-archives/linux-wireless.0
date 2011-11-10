Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33519 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab1KJJmG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 04:42:06 -0500
Date: Thu, 10 Nov 2011 15:13:00 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Paul Stewart <pstew@google.com>
Subject: Re: [PATCH 4/4] ath9k_hw: Fix tx power settings for AR9003
Message-ID: <20111110094258.GA1753@vmraj-lnx.users.atheros.com> (sfid-20111110_104504_254617_9713C66E)
References: <1320742368-11343-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1320742368-11343-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 08, 2011 at 02:22:48PM +0530, Rajkumar Manoharan wrote:
> Retriving tx power for 2x2 and 3x3 chainmask is not handled
> properly. While calculating tx power for 2x2, 3 dBm was reduced
> and for 3x3, 5 dBm was reduced which should be added back when
> retriving.
> 
> Cc: Paul Stewart <pstew@google.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
John,

Drop this one. Will sent v2 patch.

--
Rajkumar
