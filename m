Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44060 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0EGKs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 06:48:57 -0400
Received: by bwz19 with SMTP id 19so491582bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 07 May 2010 03:48:54 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCHv2] rt2x00: rt2800: use correct txop value in tx descriptor
Date: Fri, 7 May 2010 12:48:42 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201005071103.08186.helmut.schaa@googlemail.com> <201005071148.12280.helmut.schaa@googlemail.com> <u2ia32f33a41005070333m4c3b4831q2d0afa42c3669807@mail.gmail.com>
In-Reply-To: <u2ia32f33a41005070333m4c3b4831q2d0afa42c3669807@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005071248.42149.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag 07 Mai 2010 schrieb Ivo Van Doorn:
> On Fri, May 7, 2010 at 11:48 AM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
> > I guess you mean rt2x00queue_create_tx_descriptor in rt2x00queue.c, right?
> > It's not exactly the same but at least the check for the first fragment are
> > there already. We could also move it there. Why I've decided to put it in
> > rt2x00ht.c is because it only applies to HT devices ;)
> >
> > If you'd prefer to have it in rt2x00queue I'm glad to resend.
> 
> Ah true this is HT stuff only. I'll look into the exact code later, and perhaps
> I'll update it later. But this patch can be merged:
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Ok, thanks for the quick review.

Helmut
