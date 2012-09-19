Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44734 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949Ab2ISS4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 14:56:43 -0400
Received: by qaas11 with SMTP id s11so1232010qaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2012 11:56:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <505A1206.4020606@msgid.tls.msk.ru>
References: <1348053493-22955-1-git-send-email-jarl@softace.dk> <505A1206.4020606@msgid.tls.msk.ru>
From: Jarl Friis <jarl@softace.dk>
Date: Wed, 19 Sep 2012 20:56:22 +0200
Message-ID: <CAOjsGA3BgzBn-YOEFYFs5HqLAh4_d46Juj1M-XYooqXeVtn9uw@mail.gmail.com> (sfid-20120919_205655_253029_4567AE8B)
Subject: Re: [PATCH 1/2] Added information about which firmware file is being requested.
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/19 Michael Tokarev <mjt@tls.msk.ru>:
> On 19.09.2012 15:18, Jarl Friis wrote:
>
>> +     b43info(ctx->dev->wl, "Requesting firmware file '%s'\n", ctx->fwname);
>>       err = request_firmware(&blob, ctx->fwname, ctx->dev->dev->dev);
>
> Hmm.  I wonder if this should be printed in request_firmware()
> itself instead of in all callers?

Now that you mention it, I also think that is a much better idea.
However that would be a much more central place to do the change, so I
would gladly see somebody else do that patch (in replacement of mine)

Jarl
