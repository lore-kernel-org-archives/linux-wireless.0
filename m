Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2JYW1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 18:27:39 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so2330571pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 15:27:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVM_9TkKmMs0MyyiuO8TAUSLkBJTWiQ8+4AAa19YG+guCw@mail.gmail.com>
References: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
	<CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com>
	<20121024194547.GA19060@shredder>
	<CAJ-VmonEZbKiVqnu1SDDbNDTj3qeWB2QgTN=h3NHdiZrMp8LDA@mail.gmail.com>
	<CAJ-VmonzYsUsSOyr34Xj9=mTpsHEbGNUS2RoN=BenqthGfakVw@mail.gmail.com>
	<20121024220813.GB6723@shredder>
	<CAJ-VmokGeCLY8pCpL5H0VgznXnB-ob1z_sPaSQUZn0PengSgow@mail.gmail.com>
	<CAJ-Vmo=-Dj+Le8y0EYNgVednUT7GTedSwdNP5q1P5iLKymRBLg@mail.gmail.com>
	<CAJ-Vmom0cg09C1D2Eh79K2zoOxL0Ry7g3+DC2iNGBFTa4+Zhzg@mail.gmail.com>
	<CAG6hwVM_9TkKmMs0MyyiuO8TAUSLkBJTWiQ8+4AAa19YG+guCw@mail.gmail.com>
Date: Thu, 25 Oct 2012 15:27:39 -0700
Message-ID: <CAJ-Vmok3+ts43ow_Btj7sG3DfWNeD7O=gNWagJrSGkBWFvyQMQ@mail.gmail.com> (sfid-20121026_002742_587813_EF9760FF)
Subject: Re: [ath9k-devel] ath9k_htc and reported mactime
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 October 2012 15:25, Thomas Pedersen <thomas@cozybit.com> wrote:

>> Thomas, is the TSF in the RX status descriptor actually 32 bits, or is
>> this a printing error?
>
> Looking at the printk again, I'm pretty sure I'm just an idiot and the
> printed value is being truncated to 32 bits. Will test and verify the
> TSF wraps correctly again.

Thanks.

There's a few other TSF tweaks that could go in after this - to make
things more correct around the wrap boundary.



Adrian
