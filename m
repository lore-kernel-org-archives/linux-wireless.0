Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53943 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0ITHPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 03:15:40 -0400
Received: by vws3 with SMTP id 3so3076397vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 00:15:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <SNT113-W3652C8510E7AB89D2036ECF17E0@phx.gbl>
References: <SNT113-W3652C8510E7AB89D2036ECF17E0@phx.gbl>
Date: Mon, 20 Sep 2010 09:15:39 +0200
Message-ID: <AANLkTin7eTsGXBb5VXsRU_4rwvFpU3-BYe+2w5352SRE@mail.gmail.com>
Subject: Re: Compiling carl9170
From: Christophe Chapuis <chris.chapuis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually, the carl9170 driver has been included in compat-wireless,
but the compilation of compat-wireless fails since then (latest
successful baking was sept. 12th). I hope this will be fixed soon.
Having the same adapter as you, I'm also following the situation daily :)

On Mon, Sep 20, 2010 at 4:32 AM, Dale Turner <rx_guy@hotmail.com> wrote:
>
> Hello.
>
> Can someone tell me how to compile the carl9170 module
> WITHOUT compiling a complete kernel. I just purchased a TP-Link WN821N
> based on the capabilities of this driver, but am disappointed that I
> currently don't have the module.
>
> I am familiar with the
> compat-wireless packages as I have needed to compile the ath9k_htc
> driver for my other adapter (TP-Link WN721N), but the carl driver does
> not seem to be available in that package.
>
> Can anyone help??
>
> Thanks in advance.
>
> (Sorry about the first post without a subject)
>
> Dale Turner
>                                          --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
