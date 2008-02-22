Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:25403 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbYBVPq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 10:46:56 -0500
Received: by mu-out-0910.google.com with SMTP id i10so881415mue.5
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2008 07:46:54 -0800 (PST)
Message-ID: <c6b1100b0802220746s3441d28cj92896618bbb57bde@mail.gmail.com> (sfid-20080222_154659_759158_57C483E7)
Date: Fri, 22 Feb 2008 15:46:54 +0000
From: "Chris Clayton" <chris2553@googlemail.com>
To: ivdoorn@gmail.com
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <200802181911.32128.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <200802181911.32128.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,

On 18/02/2008, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>

[...]

> Above traces should be enough, but to determine where rt2x00 broke
>  down approximatly I need to have a few test result on specific moments.
>  Could you test the kernel with the following versions:
>
>  rt2x00 2.0.11   2d68de3efa62655d551092f5c787505735d561ad
>  rt2x00 2.0.12   a3c7aa58df7df80aa05f166fe3e42482247164cf
>  rt2x00 2.0.13   5a6012e105ae1664cd2841c33bf59fbdd8d4dbcc
>
>  Checking those out is simply a matter of:
>  git branch 2.0.11 2d68de3efa62655d551092f5c787505735d561ad
>  git checkout 2.0.11
>

OK, we seem to be struggling a little, so I've built an installed git
and cloned Linus' 2.6 tree. My wireless network dies after a few pings
with rt2x00 2.0.11.

>  No further bisecting is needed, but with above tests I can at least
>  narrow it down to find the cause of this issue.
>

If you need me to bisect, just shout. Please be patient though, I'm
exploring new territory here :-)

Thanks

Chris
>  Thanks.
>
>
>  Ivo
>
>


-- 
Beauty is in the eye of the beerholder.
