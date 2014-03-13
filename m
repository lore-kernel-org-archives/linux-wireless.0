Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3708 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaCMFQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 01:16:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] ath10k: add recalc RTS/CTS protection method
References: <1393837661-15235-1-git-send-email-marek.kwaczynski@tieto.com>
Date: Thu, 13 Mar 2014 07:16:46 +0200
In-Reply-To: <1393837661-15235-1-git-send-email-marek.kwaczynski@tieto.com>
	(Marek Kwaczynski's message of "Mon, 3 Mar 2014 10:07:41 +0100")
Message-ID: <87txb2d6f5.fsf@kamboji.qca.qualcomm.com> (sfid-20140313_061711_185773_6B3A99D0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Kwaczynski <marek.kwaczynski@tieto.com> writes:

> Add recalculation of RTS/CTS protection when one or more legacy
> stations are connected to ath10k. In this case enable RTS/CTS
> protection and set sw retry profile are needed in the FW.
> Without this change legacy station is starved and has very low
> throughput.
>
> Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
