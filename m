Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:39904 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3FQGfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 02:35:48 -0400
Received: by mail-qc0-f172.google.com with SMTP id j10so1403863qcx.3
        for <linux-wireless@vger.kernel.org>; Sun, 16 Jun 2013 23:35:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmonxpTv0=5M6faG=UzswdH=c4+L1HYMXatnmssx1Rz7vLQ@mail.gmail.com>
References: <CAJ-VmonxpTv0=5M6faG=UzswdH=c4+L1HYMXatnmssx1Rz7vLQ@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 17 Jun 2013 16:35:27 +1000
Message-ID: <CAGRGNgWJr=EahOWeQxpchCAyv5di-WnwyL9hvJa3XYFf64OSxg@mail.gmail.com> (sfid-20130617_083551_915886_B065F77A)
Subject: Re: ath3k hackery; doing it in userland
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

On 17 June 2013 16:27, Adrian Chadd <adrian@freebsd.org> wrote:
> Hi,
>
> As part of general freebsd wireless hackery I've found a need to port
> ath3k to freebsd.
>
> Whilst doing it, I asked - why isn't this in userland? All it's doing
> is pushing firmware in. It doesn't have to be in the kernel!
>
> So, without further ado:
>
> https://github.com/erikarn/ath3k
>
> I'm using the libusb 1.0 API so it should be portable between OSes.
>
> There's some interesting issues that have crept up - specifically, the
> AR3012 resets after loading in the syscfg and thus doesn't take the
> "set normal mode" and "change VID".
>
> So, why's this in the kernel?

A further question: why isn't this in usb-modeswitch or some similar
"make my dumb USB device work" system?

Thanks,

--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
