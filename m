Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57354 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbdJTMie (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Oct 2017 08:38:34 -0400
Received: from mail-io0-f198.google.com ([209.85.223.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1e5WZN-0007lu-4C
        for linux-wireless@vger.kernel.org; Fri, 20 Oct 2017 12:38:33 +0000
Received: by mail-io0-f198.google.com with SMTP id d66so10586846ioe.23
        for <linux-wireless@vger.kernel.org>; Fri, 20 Oct 2017 05:38:33 -0700 (PDT)
Date: Fri, 20 Oct 2017 07:38:30 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Ryan Mounce <ryan@mounce.com.au>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        =?utf-8?B?0JDQvdC00YDQtdC5INCY0LLQsNC90L7Qsg==?= <wowz89@mail.ru>
Subject: Re: [wireless-regdb] [PATCH] wireless-regdb: Add 5 Ghz rules for
 Kazakhstan (KZ)
Message-ID: <20171020123830.rrv3ldmqpmjp4zpr@ubuntu-xps13> (sfid-20171020_143845_721797_49477259)
References: <20171019213834.23127-1-seth.forshee@canonical.com>
 <CAN+fvRZo6UtqDZN2Mhukx8EOiO+JcpSBvbM3RRka4kzscWjLDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN+fvRZo6UtqDZN2Mhukx8EOiO+JcpSBvbM3RRka4kzscWjLDA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 20, 2017 at 09:48:25AM +1030, Ryan Mounce wrote:
> This is missing the DFS domain, which is almost certainly DFS-ETSI as
> KZ is in ITU region 1.

D'oh, I did forget that, good catch. I'll send out an update.

> 
> Regards,
> Ryan Mounce
> 
> On 20 October 2017 at 08:08, Seth Forshee <seth.forshee@canonical.com> wrote:
> > Add rules for 5150-5250 MHz, 5250-5350 MHz, and 5470-5725 Mhz
> > based on the documents at [1] and [2].
> >
> > [1] http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_chastot_no34.pdf
> > [2] http://adilet.zan.kz/rus/docs/P000001379_
> >
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > ---
> >  db.txt | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/db.txt b/db.txt
> > index e48f9a619651..96d8fda44284 100644
> > --- a/db.txt
> > +++ b/db.txt
> > @@ -689,8 +689,14 @@ country KY: DFS-FCC
> >         (5490 - 5730 @ 160), (24), DFS
> >         (5735 - 5835 @ 80), (30)
> >
> > +# Source:
> > +# http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_chastot_no34.pdf
> > +# http://adilet.zan.kz/rus/docs/P000001379_
> >  country KZ:
> >         (2402 - 2482 @ 40), (20)
> > +       (5150 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
> > +       (5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
> > +       (5470 - 5725 @ 80), (20), NO-OUTDOOR, DFS
> >
> >  country LB: DFS-FCC
> >         (2402 - 2482 @ 40), (20)
> > --
> > 2.14.1
> >
> >
> > _______________________________________________
> > wireless-regdb mailing list
> > wireless-regdb@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/wireless-regdb
