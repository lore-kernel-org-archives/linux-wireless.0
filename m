Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7079 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbaEPNxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 09:53:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	<johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2 V3] ath10k: Fix pmf for action frames
References: <1397467642-23544-1-git-send-email-marek.kwaczynski@tieto.com>
	<1397467642-23544-2-git-send-email-marek.kwaczynski@tieto.com>
Date: Fri, 16 May 2014 16:53:27 +0300
In-Reply-To: <1397467642-23544-2-git-send-email-marek.kwaczynski@tieto.com>
	(Marek Kwaczynski's message of "Mon, 14 Apr 2014 11:27:22 +0200")
Message-ID: <87fvk94yp4.fsf@kamboji.qca.qualcomm.com> (sfid-20140516_155341_509346_7A1E5582)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Kwaczynski <marek.kwaczynski@tieto.com> writes:

> Fix sending and receiveing protected managment frames.
> Lack of protected flag for received protected action frames
> causes report these frames as unprotected robust action frames.
> If the driver in AP mode sent frame with protected flag and
> CCMP header using IEEE80211_KEY_FLAG_SW_MGMT_TX flag,
> the FW encrypted frames once again. From user side all
> received SA Query Requests and Responses were skipped and
> all protected action frames were sent as malformed packets.
>
> Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
