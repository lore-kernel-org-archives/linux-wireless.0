Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33934 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbcGVA3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 20:29:55 -0400
Received: by mail-io0-f180.google.com with SMTP id q83so91831994iod.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 17:29:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1469088884-28469-1-git-send-email-rajan.vaja@gmail.com>
References: <1469088884-28469-1-git-send-email-rajan.vaja@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 22 Jul 2016 10:29:34 +1000
Message-ID: <CAGRGNgU91PirkgsytVopGhLyKQ-gQQ9rSmSjeoFU8T4J7dJQgg@mail.gmail.com> (sfid-20160722_022958_326855_7347777D)
Subject: Re: [PATCH] hostap: Use memdup_user() to reuse code
To: Rajan Vaja <rajan.vaja@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Thu, Jul 21, 2016 at 6:14 PM, Rajan Vaja <rajan.vaja@gmail.com> wrote:
> Fix coccicheck warning which recommends to
> use memdup_user() instead of reimplementing its
> code.
>
> This patch fixes below coccicheck warnings:
>
> drivers/net/wireless/intersil/hostap/hostap_ioctl.c:3044:9-16: WARNING
> opportunity for memdup_user
> drivers/net/wireless/intersil/hostap/hostap_ioctl.c:3806:9-16: WARNING
> opportunity for memdup_user
>
> Signed-off-by: Rajan Vaja <rajan.vaja@gmail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
