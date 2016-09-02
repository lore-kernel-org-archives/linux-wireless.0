Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36219 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753689AbcIBQSJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 12:18:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] rtl8723au: remove declaration of unimplemented functions
References: <1472821069-5437-1-git-send-email-luca@lucaceresoli.net>
Date: Fri, 02 Sep 2016 19:18:01 +0300
In-Reply-To: <1472821069-5437-1-git-send-email-luca@lucaceresoli.net> (Luca
        Ceresoli's message of "Fri, 2 Sep 2016 14:57:44 +0200")
Message-ID: <87a8fq2s3q.fsf@purkki.adurom.net> (sfid-20160902_181814_715291_439238D6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Ceresoli <luca@lucaceresoli.net> writes:

> These functions have been declared without any implementation since
> the first commit (364e30ebd2dbaccba430c603da03e68746eb932a) and there
> has been no mention of them in following commits.
>
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Cc: linux-kernel@vger.kernel.org
>
> ---
>
> Changes v1 -> v2:
> - improve the commit message.
> ---
>  drivers/staging/rtl8723au/include/recv_osdep.h | 3 ---
>  1 file changed, 3 deletions(-)

Please prefix staging drivers with "staging:".

-- 
Kalle Valo
