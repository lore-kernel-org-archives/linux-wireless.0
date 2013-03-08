Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38471 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3CHXc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 18:32:57 -0500
Received: by mail-wi0-f174.google.com with SMTP id hi8so49033wib.7
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2013 15:32:55 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 8 Mar 2013 15:32:55 -0800
Message-ID: <CAJ-Vmo=+QWZus5j2mAJH49+eYSR8hUDa7k8bA8CbJJxGPp1N2A@mail.gmail.com> (sfid-20130309_003300_526925_BAA89646)
Subject: [Announce] open ath9k firmware
From: Adrian Chadd <adrian@freebsd.org>
To: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I hate fanfare.

You can all thank Luis Rodriguez for his ridiculously long and hard
fighting to get this stuff pushed through the grinder to make this
happen.

There's also been a hard working team of developers behind the scene -
Felix Fietkau, Eugene Krasnikov, Sujith Manoharan, and the team from
Cozybit. They've been working hard to get the codebase converted over
to using the open source tensilica toolchain and finding/fixing up any
silly issues that may creep up from that.

I've just been involved in shepharding this stuff into a sensible
shape and pushing it through the final stage (legal review) before
publication.

You can find it here:

https://github.com/qca/open-ath9k-htc-firmware

There's a bunch of sorely needed work to do in the short term:

* felix has a replacement cmake build system that I'd like to now integrate;
* there's lots of build warnings which need to be removed (and then
build this thing using -Wall -Werror);
* some general code cleanup and documentation wouldn't be rejected -
but I don't really want any sweeping code changes to go in until we've
tidied up the build warnings and validated that the image(s) work
right.

I plan on doing some test builds shortly. I plan on bumping the
firmware to 1.4 once felix's cmake system is in place and people have
validated that this work.s

Thanks,



Adrian
