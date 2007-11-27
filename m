Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:43673 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbXK0Akl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 19:40:41 -0500
Received: by py-out-1112.google.com with SMTP id u77so1810497pyb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 16:40:40 -0800 (PST)
Message-ID: <43e72e890711261640o7edb5654u27a1c0fd455c3fb8@mail.gmail.com> (sfid-20071127_004045_473243_F6F1E111)
Date: Mon, 26 Nov 2007 19:40:40 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [PATCH 3/3] ath5k: export signal quality values
Cc: "Bruno Randolf" <bruno@thinktube.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com
In-Reply-To: <40f31dec0711230327w6e929b1ay7769af8553e713b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1195815123-22375-1-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-2-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-3-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-4-git-send-email-bruno@thinktube.com>
	 <40f31dec0711230327w6e929b1ay7769af8553e713b0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 23, 2007 6:27 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2007/11/23, Bruno Randolf <bruno@thinktube.com>:
>
> > store the last noise floor in ath5k_hw and report signal, noise and link
> > quality values to mac80211, which in turn makes them show up in iwconfig.
> >
> > ath5k.h, phy.c:
> > Changes-licensed-under: ISC
> >
> > base.c:
> > Changes-licensed-under: 3-clause-BSD
> >
> > Signed-off-by: Bruno Randolf <bruno@thinktube.com>

> Acked-by: Nick Kossifidis <mickflemm@gmail.com>

This patch series depends on your previous debug.[ch] patches. If
that's ACK'ed (I'll review next) then:

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
