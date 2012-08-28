Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34748 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2H1Nix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 09:38:53 -0400
Received: by obbuo13 with SMTP id uo13so10384267obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2012 06:38:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346146736.3087.12.camel@inferno>
References: <1346146736.3087.12.camel@inferno>
Date: Tue, 28 Aug 2012 19:08:52 +0530
Message-ID: <CAD2nsn0uis8_GnNnR2p84TkDmphPoHe9LGTn2TNNZ18tCBxkog@mail.gmail.com> (sfid-20120828_153856_569744_199BAE40)
Subject: Re: ath9k AR9287 freeze linux system
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: =?ISO-8859-1?B?THXtcyBE7WF6IEdvbnrhbGV6?= <luis.hlodwig@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Aug 28, 2012 at 3:08 PM, Luís Díaz González
<luis.hlodwig@gmail.com> wrote:
> The last two releases compat-wireless (2012-08-26 and 2012-08-27) freeze
> my linux system.

thanks for reporting.
*Please provide some information/call trace if you can get(you can
attach a photograph of the trace :) )
*like what did you do(sending traffic, suspend resume, keep the
station idle?) to see the freeze.
*I would try to recreate in my ubuntu 2.6.32.. kernel.
*are you using btcoex in the driver sudo modprobe ath9k btcoex_enable=1  ?


>
> I'm not a developer, I'm a simple user
>
> Debian Squeeze 2.6.32
> wireless card  AR9287
>
>
> thanks,
> luis
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
