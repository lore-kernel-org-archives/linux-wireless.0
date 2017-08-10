Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:38308 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbdHJPTV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 11:19:21 -0400
Received: by mail-it0-f53.google.com with SMTP id m34so14521747iti.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Aug 2017 08:19:21 -0700 (PDT)
Date: Thu, 10 Aug 2017 10:19:19 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Vasiliy Safronov <vvsprog@gmail.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: Update regulatory rules for Kazakhstan (KZ) on 5GHz
Message-ID: <20170810151919.lnsserhjcw2xrgy2@ubuntu-hedt> (sfid-20170810_171945_415955_CE50439A)
References: <CALfe80gmDFDnvT=MvN8891wudBEAmeQpH1X1_wNzQpkhbLSOVQ@mail.gmail.com>
 <20170703175055.tnnweqg2uyyw2rnc@ubuntu-xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170703175055.tnnweqg2uyyw2rnc@ubuntu-xps13>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 03, 2017 at 12:50:55PM -0500, Seth Forshee wrote:
> On Mon, Jun 26, 2017 at 10:00:13AM +0600, Vasiliy Safronov wrote:
> > Please add support 5ghz for Kazakhstan.
> > In Kazakhstan there are no restrictions up to 100mW
> > country KZ: DFS-ETSI
> >  (2402 - 2482 @ 40), (20)
> >  (5170 - 5250 @ 80), (20), AUTO-BW
> >  (5250 - 5330 @ 80), (20), DFS, AUTO-BW
> >  (5650 - 5730 @ 80), (30), DFS
> >  (5735 - 5835 @ 80), (30)
> > 
> > http://adilet.zan.kz/rus/docs/P000001379_
> > S 5.282 etc
> 
> Thanks for the submission, and apologies for the slow response. I've
> been trying to find some time to validate the changes against the
> document you linked to but haven't managed to get it done yet. I hope to
> be able to take a look at this soon.

Once again sorry for the delay.

I've spent some time trying to look over the document (rather a Google
translation of the document to English). I'm not confident I understand
it completely, and I'm also not entirely confident of the values you
provided. If you could explain how you arrived at those values and
answer some questions it might help.

The document has two tables for each band. The first table seems to be
the ITU regulations for the band in all three regions, and the second is
specific to Kazakhstan. If I rely on the latter then I must conclude
that the 5 GHz band shouldn't be included. Am I misinterpreting
something?

I also haven't been able to determine the basis for your power limits,
can you plese specify where these came from?

Thanks,
Seth
