Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbaBRL4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 06:56:41 -0500
Date: Tue, 18 Feb 2014 12:59:01 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: Re: Power saving features for iwl4965
Message-ID: <20140218115900.GA17587@redhat.com> (sfid-20140218_125646_194797_AF689FA1)
References: <20120418203543.GA16000@x61.home>
 <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home>
 <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com>
 <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com>
 <20130611185120.GA8751@x61.home>
 <20140218105755.GD1741@redhat.com>
 <CANUX_P1TdHUXdauuB=dnShtg9PdMBCi=G3hn0gZ9m8F4b7o=jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P1TdHUXdauuB=dnShtg9PdMBCi=G3hn0gZ9m8F4b7o=jw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 18, 2014 at 01:32:44PM +0200, Emmanuel Grumbach wrote:
> On Tue, Feb 18, 2014 at 12:57 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Tue, Jun 11, 2013 at 08:51:20PM +0200, Tino Keitel wrote:
> >> On Mon, Jun 03, 2013 at 16:18:05 +0200, Stanislaw Gruszka wrote:
> >>
> >> > Could you try this experimental patch?
> >>
> >> Hi,
> >>
> >> on top of kernel 3.9.4 (with TuxOnIce patch), iwconfig wlan0 power on
> >> now saves more than 1 W on my ThinkPad X61s with iwl4965. I can finally
> >> switch to a recent kernel. Thanks a lot.
> >
> > This patch stuck on mailing list far too long, I'll post it. Even if it
> > crash firmware on 3945, power save is disabled by default.
> >
> 
> I'd be very surprised if this patch helped. I guess you took the code
> from iwlwifi in which we have enabled shadow registers for 7000
> series. This HW is problematic but it doesn't exit on 4965.

It is besed on old iwlwifi code (when iwlwifi & iwlegacy were one driver).

Stanislaw
