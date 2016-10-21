Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34894 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755413AbcJUQyh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 12:54:37 -0400
Received: by mail-wm0-f45.google.com with SMTP id c78so5671070wme.0
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 09:54:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bffb5d2b-03f3-f451-dd01-ef2c796bfc30@gmail.com>
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
 <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com> <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
 <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com> <bffb5d2b-03f3-f451-dd01-ef2c796bfc30@gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 21 Oct 2016 18:54:35 +0200
Message-ID: <CA+BoTQmrLmwOK-XZQKBubop0joUvX8zUfgs3h4UTVUDJe_-AgQ@mail.gmail.com> (sfid-20161021_185441_098958_34D0CCB0)
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
To: Oliver Zemann <oliver.zemann@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 October 2016 at 18:25, Oliver Zemann <oliver.zemann@gmail.com> wrote:
> The problem is gone with kernel 4.7.3 on armbian - both compex cards work
> (wle600, wle900), unfortunately that kernel does not support sfp (seems l=
ike
> its kind of proprietary drivers from clearfog). So its a driver issue but=
 i
> have no clue who to contact or where to file a bug report. The only
> available kernel which supports sfp (from solidrun, vendor of the clearfo=
g
> board) is 4.4.23
>
> I am wondering if i could simply checkout the 4.4.x sources, merge the
> atheros drivers in it and try to rebuild the kernel?

That's what backports[1] are for.

The problem could be in the pci subsystem though so backporting the
driver itself might not solve your problem.

[1]: https://wireless.wiki.kernel.org/en/users/drivers/ath10k/backports


Micha=C5=82
