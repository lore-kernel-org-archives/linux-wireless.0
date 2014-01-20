Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50081 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaATQ7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 11:59:52 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: AP mode, set UAPSD params correctly
References: <1390234821-4405-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 20 Jan 2014 18:59:46 +0200
In-Reply-To: <1390234821-4405-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Mon, 20 Jan 2014 17:20:20 +0100")
Message-ID: <8738kilhbx.fsf@kamboji.qca.qualcomm.com> (sfid-20140120_175955_495193_18E705BF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Move UAPSD params settings after peer assoc
> command. This is required to setup UAPSD
> params correctly.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

This is a pretty vague description. What is correct today can be totally
wrong tomorrow :)

So I would prefer that you describe a bit more about this change. At
least describe the bug you are fixing (or mention the motivation behind
the change).

-- 
Kalle Valo
