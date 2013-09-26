Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53753 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3IZOa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 10:30:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: make monitor vdev down before stoping it
References: <1380024384-30512-1-git-send-email-marek.puzyniak@tieto.com>
Date: Thu, 26 Sep 2013 17:30:46 +0300
In-Reply-To: <1380024384-30512-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Tue, 24 Sep 2013 14:06:24 +0200")
Message-ID: <871u4bpsdl.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_163100_565851_08413629)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> Following sequence causes FW crash:
> -monitor vdev up,
> -monitor vdev stop,
> -monitor vdev delete.
> Making monitor vdev down before stoping it works ok:
> -monitor vdev up,
> -monitor vdev down,
> -monitor vdev stop,
> -monitor vdev delete.
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>

Thanks, applied.

-- 
Kalle Valo
