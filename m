Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38801 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbaLWPYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 10:24:07 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: fix low TX rates when IBSS and HT
References: <1418719980-19753-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 23 Dec 2014 17:23:59 +0200
In-Reply-To: <1418719980-19753-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 16 Dec 2014 09:52:59 +0100")
Message-ID: <87fvc6e6eo.fsf@kamboji.qca.qualcomm.com> (sfid-20141223_162418_332844_31630D64)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> This fix TX problem when IBSS used in HT mode.
> Before we used 6Mbps all the time for TX direction.
>
> Reported-by: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo
