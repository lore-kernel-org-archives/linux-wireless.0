Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753655AbcHYPTK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 11:19:10 -0400
Date: Thu, 25 Aug 2016 17:18:32 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mathias Kresin <dev@kresin.me>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: add support for mac addr from device tree
Message-ID: <20160825151832.GB9256@redhat.com> (sfid-20160825_172043_091170_CCF9027A)
References: <1472113162-26915-1-git-send-email-dev@kresin.me>
 <20160825093330.GA2827@redhat.com>
 <CABwW5nkxpX_SsCorU0kuuOVDcNP5QARdyTbP=AWM5=QTZOW=eA@mail.gmail.com>
 <20160825131907.GA7834@redhat.com>
 <CABwW5n=Jomr+EO4dp3mzhV0HFxdfrAJuc=cZv8fdmRe31OS+3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABwW5n=Jomr+EO4dp3mzhV0HFxdfrAJuc=cZv8fdmRe31OS+3Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2016 at 05:03:06PM +0200, Mathias Kresin wrote:
> 2016-08-25 15:19 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> > On Thu, Aug 25, 2016 at 01:12:22PM +0200, Mathias Kresin wrote:
> >> 2016-08-25 11:33 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> >> > On Thu, Aug 25, 2016 at 10:19:22AM +0200, Mathias Kresin wrote:
> 
> >> CPE = Customer Premises Equipment or the small plastic box from your
> >> ISP at home. The whole point of the patch is that the MAC stored in
> >> the wifi EEPROM might not be unique and need to be overridden. I'm
> >> aware of three different "home router", where each model has the same
> >> generic ralink MAC address stored in the wifi EEPROM. This can cause
> >> nasty issues.
> >
> > I think we still want MAC from EEPROM instead of random one on systems
> > without OF. Otherwise we could just use random MAC every time, but this
> > does not seems lika a good idea.
> 
> Either I got you wrong, the code does something different than I
> intended/tested or you misread the code.

I misread the patch. It's ok (except the changelog).

Thanks
Stanislaw
