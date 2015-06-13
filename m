Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:33333 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbbFMUNP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 16:13:15 -0400
Received: by lacdj3 with SMTP id dj3so17349791lac.0
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2015 13:13:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557B1A2F.1010608@mindchasers.com>
References: <557B1A2F.1010608@mindchasers.com>
Date: Sat, 13 Jun 2015 23:13:13 +0300
Message-ID: <CANUX_P1Q9pkHF6xVgUJyAF_-x9n_g4TfaT9cr2dej7jxp+ZXTg@mail.gmail.com> (sfid-20150613_221339_670524_F1C6B6D1)
Subject: Re: iwlwifi in AP mode is experimental?
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Robert E. Cochran" <wifi@mindchasers.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Robert,

On Fri, Jun 12, 2015 at 8:43 PM, Robert E. Cochran <wifi@mindchasers.com> wrote:
> Hello,
>
> On wireless.wiki.kernel.org, iwlwifi is listed as experimental for AP Mode.
>
> We have done some basic testing with a 3160 card in AP mode & hostapd
> without issue.  Now we need to determine if it makes sense to ramp up a
> rigorous test plan for it.

3160 should provide decently support AP mode. Basically, I can tell
that devices driven by iwlmvm are better tested in AP mode. Note that
the hardware is not designed for AP mode and the AP mode suffers from
limitations in terms of number of clients etc...

>
> Is AP mode with iwlwifi basically a "use at your own risk" scenario?  Can I
> expect AP mode to be supported more fully in the future?  Is there a
> particular HW module that does AP mode better than others?  Is there a list
> of missing features?  Are others using iwlwifi for AP mode in a  product?

Unless you have a support business agreement, anything from upstream
is "at your own risk" :) We do provide support and if you have an
issue, we will try to help. I can't think about anything specific that
is not supported, but don't expect a full blown commercial AP that can
support 256 concurrent clients etc...
I think that we have customers who made an AP with iwlwifi. There is
no Intel HW that can give you a better support for AP besides the fact
that 3160 doesn't support MIMO and is definitely the low end of
Intel's devices. But that's something you are surely aware of.

>
> Any additional, current information on this will be greatly appreciated.
>
> Thank you,
>
> Bob
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
