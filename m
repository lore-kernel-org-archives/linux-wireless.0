Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50184 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1FJJQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 05:16:42 -0400
Received: by gxk21 with SMTP id 21so1562188gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 02:16:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DF1D867.4060108@seemoo.tu-darmstadt.de>
References: <4DF1D867.4060108@seemoo.tu-darmstadt.de>
Date: Fri, 10 Jun 2011 17:16:42 +0800
Message-ID: <BANLkTintfDcPJWoZkD2tu-Gnn5w6BJroXg@mail.gmail.com> (sfid-20110610_111646_057821_AEC30612)
Subject: Re: Compiling meshd in FreeBSD 8.2
From: Adrian Chadd <adrian@freebsd.org>
To: Rodrigo do Carmo <rodrigo.dcarmo@seemoo.tu-darmstadt.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please subscribe to freebsd-wireless@freebsd.org :-)



Adrian
(freebsd wireless guy)

On 10 June 2011 16:40, Rodrigo do Carmo
<rodrigo.dcarmo@seemoo.tu-darmstadt.de> wrote:
> Hi,
>
> First of all, I'm sorry if this is the wrong place to put this kind of
> questions. I would like to ask you, if someone could give me a hand with
> this. I'm trying to compile the meshd in a FreeBSD 8.2, but I can't get rid
> of this error message when doing make: "meshd.c:83: error: 'struct
> <anonymous>' has no member named 'variable'"... I've applied the patch to
> the kernel, the path to the openssl libraries are OK, in fact I also used
> the 1.0.0-beta2 as stated in the example, compiled from scratch. I also get
> the same error in a FreeBSD 6.4. Does anyone went to something similar?
>
> Thanks so much in advance,
> Rodrigo.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
