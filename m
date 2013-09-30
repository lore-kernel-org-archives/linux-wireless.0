Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:60101 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3I3Qxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 12:53:45 -0400
Message-ID: <1380559680.32539.1.camel@paschendale> (sfid-20130930_185348_302018_88E537B7)
Subject: Re: [PATCH 12/12] wlcore: always register dummy hardirq
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 30 Sep 2013 19:48:00 +0300
In-Reply-To: <CAB3XZEeer+NTKwWc5GkjZQdswSkPfsGhinvpcK2BbarqjCeA5A@mail.gmail.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	 <1378218848-7853-12-git-send-email-eliad@wizery.com>
	 <1378799431.4799.63.camel@porter.coelho.fi>
	 <CAB3XZEeer+NTKwWc5GkjZQdswSkPfsGhinvpcK2BbarqjCeA5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-09-11 at 09:48 +0200, Eliad Peller wrote:
> On Tue, Sep 10, 2013 at 10:50 AM, Luca Coelho <luca@coelho.fi> wrote:
> > On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
> >> From: Arik Nemtsov <arik@wizery.com>
> >>
> >> This keeps the kernel happy when using edge-irqs and requesting a
> >> threaded irq.
> >>
> >> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
> >> ---
> >
> > Ouch, I think this is not going to fit at all with the DT patches I
> > sent.
> >
> this is quite minor patch (only making sure we always define hardirq
> when threaded_irq is used. i don't think it should conflict (at least
> logically) with DT patches...

It will.  Just take a look at my DT patch series.  Anyway, I'll apply
this for now and whoever (if ever) take over my DT series, will have to
make sure it still works. :P

--
Cheers,
Luca.

