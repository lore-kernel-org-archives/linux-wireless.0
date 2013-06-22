Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:56432 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3FVClx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 22:41:53 -0400
Received: by mail-ve0-f170.google.com with SMTP id 14so7115669vea.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jun 2013 19:41:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8BRGbdCOaoy6E4QBVEbZRnKkHwgrWsodJwYLVs+S=KaQ@mail.gmail.com>
References: <CAPgLHd8BRGbdCOaoy6E4QBVEbZRnKkHwgrWsodJwYLVs+S=KaQ@mail.gmail.com>
Date: Fri, 21 Jun 2013 19:41:52 -0700
Message-ID: <CA++WF2O_RXLY6hvSjJ8V8Sg2eUKuWHV07MLK9ffAB7E46xw6SQ@mail.gmail.com> (sfid-20130622_044212_385164_39C79E6F)
Subject: Re: [PATCH] ipw2200: fix error return code in ipw_load()
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wei,

On 20 June 2013 19:42, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -ENOMEM in the ipw_rx_queue_alloc() error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

Looks fine, thanks.

Stanislav.
