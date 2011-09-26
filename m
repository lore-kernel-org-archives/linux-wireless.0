Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51786 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab1IZVDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 17:03:25 -0400
Received: by qyk7 with SMTP id 7so7048032qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 14:03:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316680579-5055-1-git-send-email-ilane@ti.com>
References: <1316680579-5055-1-git-send-email-ilane@ti.com>
Date: Mon, 26 Sep 2011 18:03:24 -0300
Message-ID: <CAK3JMAZG5HBDajGEuGWzcVA1h185MjN4feqEJNxayh0QneXJ2Q@mail.gmail.com> (sfid-20110926_230328_612857_7CA1843E)
Subject: Re: [PATCH] NFC: protect nci_data_exchange transactions
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: ilanelias78@gmail.com
Cc: aloisio.almeida@openbossa.org, samuel@sortiz.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ilan Elias <ilane@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/22  <ilanelias78@gmail.com>:
> From: Ilan Elias <ilane@ti.com>
>
> Protect 'cb' and 'cb_context' arguments in nci_data_exchange.
> In fact, this implements a queue with max length of 1 data
> exchange transactions in parallel.
>
> Signed-off-by: Ilan Elias <ilane@ti.com>
Acked-by: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
