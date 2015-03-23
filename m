Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1646 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbCWPx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 11:53:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v4 5/6] ath10k: add wmi support for tdls
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
	<1426849379-7562-6-git-send-email-marek.puzyniak@tieto.com>
Date: Mon, 23 Mar 2015 17:53:50 +0200
In-Reply-To: <1426849379-7562-6-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Fri, 20 Mar 2015 12:02:58 +0100")
Message-ID: <87pp7zd81d.fsf@kamboji.qca.qualcomm.com> (sfid-20150323_165402_404298_AB4F282E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> As a part of tdls implementation introduce
> tdls related wmi data structures, constant
> values and functions.
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>

This patch had non-trivial conflicts, please check carefully my
resolution in the pending branch.

  CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi.h
  CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.h
  CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.c
  CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-ops.h

-- 
Kalle Valo
