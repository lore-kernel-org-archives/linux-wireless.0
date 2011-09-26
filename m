Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44965 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1IZVAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 17:00:41 -0400
Received: by qyk30 with SMTP id 30so162274qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 14:00:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316679181-4917-1-git-send-email-ilane@ti.com>
References: <1316679181-4917-1-git-send-email-ilane@ti.com>
Date: Mon, 26 Sep 2011 18:00:40 -0300
Message-ID: <CAK3JMAZE=FZGz3JqYcK8QF2TwiXs9AuQRKSSaad4rptgWDc3Wg@mail.gmail.com> (sfid-20110926_230044_222796_C8A60FC7)
Subject: Re: [PATCH] NFC: implicitly deactivate in nci_start_poll
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
> When start_poll is called, and a target was implicitly activated,
> we need to implicitly deactivate it.
> On the other hand, when the target was activated by the user,
> we should not deactivate it.
>
> Signed-off-by: Ilan Elias <ilane@ti.com>
Acked-by: Lauro Ramos Venancio <lauro.venancio@openbossa.org>


Lauro
