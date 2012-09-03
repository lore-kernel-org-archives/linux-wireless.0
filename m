Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42758 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab2ICTYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 15:24:13 -0400
Received: by pbbrr13 with SMTP id rr13so8433783pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2012 12:24:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj985FB5PhGRqWfzpsN46Y1YdAw42w+_u4EBzUfP1vjswCnQ@mail.gmail.com>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<CAJ-Vmo=kzUW=PTRMDpxVf-pQVdozC5U_g-GPyFQ+vkRTFhe1dw@mail.gmail.com>
	<CAEFj985FB5PhGRqWfzpsN46Y1YdAw42w+_u4EBzUfP1vjswCnQ@mail.gmail.com>
Date: Mon, 3 Sep 2012 12:24:12 -0700
Message-ID: <CAJ-Vmo=sqB24R2RORbj1ArCe0mKAeoj-wUOnMkdoVGM_FyiaDQ@mail.gmail.com> (sfid-20120903_212415_877834_FCDBC458)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Adrian Chadd <adrian@freebsd.org>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 August 2012 08:24, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Hi, Adrian
>
> Appreciate your testing on this.
>

Hi,

I don't have time to test ath5k stuff. I'm just an Atheros employee
who hacks on FreeBSD in his spare time. I'm lurking to provide
feedback. :-)

I suggest that you at least wrap this in a run-time configuration item
that defaults to off or something. i'd be really worried about this
stuff having subtle bugs that aren't well documented; it may work for
you but it may induce weird behaviour in other setups.



Adrian
