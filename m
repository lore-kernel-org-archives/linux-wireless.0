Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56150 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbcICJzO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 05:55:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: hostap: Use memdup_user() to reuse code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1469088884-28469-1-git-send-email-rajan.vaja@gmail.com>
To: Rajan Vaja <rajan.vaja@gmail.com>
Cc: j@w1.fi, linux-wireless@vger.kernel.org
Message-Id: <20160903095513.C099662017@smtp.codeaurora.org> (sfid-20160903_115519_306957_C3405C84)
Date: Sat,  3 Sep 2016 09:55:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajan Vaja <rajan.vaja@gmail.com> wrote:
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
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

8432ebd66205 hostap: Use memdup_user() to reuse code

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9241109/
