Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:4524 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYADRJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 12:09:38 -0500
Received: by mu-out-0910.google.com with SMTP id i10so5350312mue.5
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jan 2008 09:09:33 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Fri, 4 Jan 2008 17:09:12 +0000
Cc: "Kalle Valo" <kalle.valo@nokia.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <200801020632.31361.chris2553@googlemail.com> <200801022002.29262.IvDoorn@gmail.com>
In-Reply-To: <200801022002.29262.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801041709.12043.chris2553@googlemail.com> (sfid-20080104_170945_735404_F589851E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 January 2008, Ivo van Doorn wrote:

<snip>

> On Wednesday 02 January 2008, Chris Clayton wrote:
> >
> > Ah, does the patch I have applied and am running need enhancement,
> > please?
>

Thanks, I'll run 2.6.24-rc6-git10 with this patch over the weekend and let you 
know if there are any problems

Chris
> ---
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c
> b/drivers/net/wireless/rt2x00/rt2x00dev.c index ff399f8..3c10a68 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c

<snip>

-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin
