Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932088AbeFTQlm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 12:41:42 -0400
Date: Wed, 20 Jun 2018 18:41:40 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tom Psyborg <pozega.tomislav@gmail.com>
Cc: Kofi Agor <nenekofi@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] rt2x00: check against flushing empty queue
Message-ID: <20180620164139.GB10723@redhat.com> (sfid-20180620_184146_068230_0AEF1B8B)
References: <1525094357-24782-1-git-send-email-sgruszka@redhat.com>
 <1525094357-24782-2-git-send-email-sgruszka@redhat.com>
 <CAOt++SdXt6YQKDZEdNxxEQOZ+sHyw2xjdUQm1DTGWdff-faJUw@mail.gmail.com>
 <20180502093922.GA2677@redhat.com>
 <CAKR_QVJUPOujZbo8N55JM8ZMDv3k2syrj2pBHwYJ60bPgHL2XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKR_QVJUPOujZbo8N55JM8ZMDv3k2syrj2pBHwYJ60bPgHL2XA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2018 at 06:22:45PM +0200, Tom Psyborg wrote:
> does it fix mt7620 bug?

It is possible that patch fixes some bug that happen also on mt7620,
but is was not that I found a reproducible bug and patch fixed it.

Stanislaw

> On 02/05/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > Hi
> >
> > On Tue, May 01, 2018 at 06:27:17AM -0600, Kofi Agor wrote:
> >> I haven't had a chance to test your patch yet, but does it resolve the tx
> >> queue flush issues? What platform are you developing/testing on?
> >
> > I'm not sure about the issue, but most likely the patch
> > does not fix it. I tested the patch on RT3062 pcie device an
> > RT3071 usb dongle.
> >
> > Regards
> > Stanislaw
> >
