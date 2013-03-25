Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45406 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3CYCXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 22:23:54 -0400
Received: by mail-wi0-f176.google.com with SMTP id hm14so9598044wib.9
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2013 19:23:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
	<CAJ-Vmo=_t0SwB0hiekXcCMgAps1noghp273O-QXGQ-1tABQvkg@mail.gmail.com>
	<CAMgrJ3buZxZermRmpUW2r3gYtUmF=3UoEo7NW9VYTkAwS7gdtQ@mail.gmail.com>
	<201303242358.17133.chunkeey@googlemail.com>
	<CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
Date: Sun, 24 Mar 2013 19:23:53 -0700
Message-ID: <CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com> (sfid-20130325_032358_755121_7F7B7858)
Subject: Re: Auth Packet TX Delay
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Robert Shade <robert.shade@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Marco Fonseca <marco@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, would you please make sure you file a bugzilla.kernel.org ticket
so this gets tracked?

It's good to know that some combination of fast channel change and
warm versus cold reset is making things better/worse.

And although a cold reset is likely a good thing to _fix_ the problem,
it still leaves the underlying DMA/PHY hangs unresolved.

But yes, please file a bugzilla ticket so this gets tracked right!

Thanks,


Adrian
