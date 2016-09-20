Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59214 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751190AbcITTK2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 15:10:28 -0400
Message-ID: <1474398624.4075.0.camel@sipsolutions.net> (sfid-20160920_211032_635593_EB456BB8)
Subject: Re: py80211 events
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <aspriel@gmail.com>
Date: Tue, 20 Sep 2016 21:10:24 +0200
In-Reply-To: <CAF7Mx6q0H4rbc1krnPkbHKibPyGAZEPh6jRC8p4sbjAU1g1cWw@mail.gmail.com> (sfid-20160920_210930_972358_DBF5273C)
References: <1474381319.4107.0.camel@sipsolutions.net>
         <CAF7Mx6q0H4rbc1krnPkbHKibPyGAZEPh6jRC8p4sbjAU1g1cWw@mail.gmail.com>
         (sfid-20160920_210930_972358_DBF5273C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-09-20 at 21:09 +0200, Arend Van Spriel wrote:
> Op 20 sep. 2016 16:22 schreef "Johannes Berg" <johannes@sipsolutions.
> net>:
> >
> > Hi Arend,
> >
> > Does py80211 support events in any way? I couldn't find anything.
> Reply from my android phone so excluding linux-wireless as they don't
> like HTML emails.
> I am pretty sure events are handled for scan results, but I did not
> abstract it. Was high on my to-do list, but been a while tinkering on
> py80211.

Luca mentioned something similar - looks like it. I suppose I might get
away with a new class - the specific case I need is looking for
regulatory events.

Thanks!

johannes
