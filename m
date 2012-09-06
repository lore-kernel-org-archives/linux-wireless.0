Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62358 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab2IFUeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 16:34:22 -0400
Received: by vcbfk26 with SMTP id fk26so3000205vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2012 13:34:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346943788.5469.12.camel@jlt4.sipsolutions.net>
References: <5048ADFC.1010708@sonymobile.com>
	<1346943788.5469.12.camel@jlt4.sipsolutions.net>
Date: Thu, 6 Sep 2012 22:34:20 +0200
Message-ID: <CAMJBoFNBT2XVPEFZhKo4vZJt+662tNr9FiLdzsWWRGj+zQEkrQ@mail.gmail.com> (sfid-20120906_223429_040668_50083D5A)
Subject: Re: [PATCH/RFC] rfkill: prevent unnecessary event generation
From: Vitaly Wool <vitalywool@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vitaly Wool <vitaly.wool@sonymobile.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, Sep 6, 2012 at 5:03 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 2012-09-06 at 16:06 +0200, Vitaly Wool wrote:
> > Prevent unnecessary rfkill event generation when the state has
> > not actually changed. These events have to be delivered to
> > relevant userspace processes, causing these processes to wake
> > up and do something while they could as well have slept. This
> > obviously results in more CPU usage, longer time-to-sleep-again
> > and therefore higher power consumption.
> >
> > Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
> > Signed-off-by: Mykyta Iziumtsev <nikita.izyumtsev@gmail.com>
>
> Looks fine to me, should I just pick it up?
>

if it's fine with you, yes, please do so :)

~Vitaly
