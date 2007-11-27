Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:5151 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549AbXK0BGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 20:06:13 -0500
Received: by py-out-1112.google.com with SMTP id u77so1825051pyb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 17:06:12 -0800 (PST)
Message-ID: <43e72e890711261706x327fd175v1317863c67065851@mail.gmail.com> (sfid-20071127_010633_687621_D7B3DBE3)
Date: Mon, 26 Nov 2007 20:06:11 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: ath5k debugging take 2
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com
In-Reply-To: <1196077433-12358-1-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1196077433-12358-1-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 26, 2007 6:43 AM, Bruno Randolf <bruno@thinktube.com> wrote:
>
> hello!
>
> this is an updated version of my debugging changes. luis i hope i have
> addressed all your comments.
>
> i have removed dumpstate to make the licensing simpler. now debug.c just
> contains stuff from base.c which always was dual BSD/GPL.
>
> debug.c and debug.h now includes the original copyright from base.c, but is
> itself licensed under the GPL. i hope in this case that will not upset the
> original authors since it is just debugging stuff specific to linux anyways.

We have and continue to go out of our way to help OpenBSD despite
their huge conspiracy theories that us, the SFLC and even the FSF are
out to get them. It was understood that at certain point certain
authors may want their new hw-related code licensed under the GPL. We
cannot force people to embrace a new licensing policy but just advice
to help our brothers. We're not going to say no to this new code if
its useful, however, it is important to note that when this happens to
files previously licensed under more a more permissive license that's
where the buck stops in regards to guaranteeing inclusion of that new
code under their code under more permissive licenses. It would still
be possible but it would involve tracking down individual segments of
files. But since git is pretty smart and keeps track of content rather
than files and since we do and if we keep using the
Change-licensed-under tag perhaps permissive license users can find an
automagic way of knowing what sections of what files are permissive
(ISC, BSD) or not (GPL).

But fortunately as you note this is only debug stuff which I do not
think they can reap benefit over. Ultimately your changes can be
licensed under the GPL if you choose. Its basically your choice. Now
I'll review the patch :)

  Luis
