Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45505 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab1JMSat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 14:30:49 -0400
Date: Thu, 13 Oct 2011 14:23:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Alwin Beukers <alwin@broadcom.com>
Subject: Re: [PATCH 22/22] brcm80211: removed file wifi.c
Message-ID: <20111013182306.GD2504@tuxdriver.com> (sfid-20111013_203101_152736_0698EE22)
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
 <1318445492-24207-23-git-send-email-arend@broadcom.com>
 <CAB=NE6XYFB4uWcRR1kSNKLaJC4W1E3uLZOd3hGEArjzsmNG4PQ@mail.gmail.com>
 <4E96A696.9040607@broadcom.com>
 <CAB=NE6XiXc=TsjQ0bCphqaprDAjrXMfoKaQTwyNu-hX2d0issA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAB=NE6XiXc=TsjQ0bCphqaprDAjrXMfoKaQTwyNu-hX2d0issA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 13, 2011 at 11:08:15AM -0700, Luis R. Rodriguez wrote:
> On Thu, Oct 13, 2011 at 1:51 AM, Arend van Spriel <arend@broadcom.com> wrote:
> > On 10/12/2011 11:54 PM, Luis R. Rodriguez wrote:
> >> On Wed, Oct 12, 2011 at 11:51 AM, Arend van Spriel <arend@broadcom.com> wrote:
> >>> From: Alwin Beukers <alwin@broadcom.com>
> >>>
> >>> Wifi.c was empty after previous cleanups, so it was removed.
> >>>
> >>> Reviewed-by: Arend van Spriel <arend@broadcom.com>
> >>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> >>
> >> Heh, remove Reviewed-by dude.
> >>
> >>   Luis
> >>
> >
> > I had a remark on this in earlier commits. So I am clearly missing the
> > point here. The author submitted this change and others for review to me
> > and I reviewed it as requested. Hence the Reviewed-by: entry.
> >
> > I have been given the task to publish these patches and I sign them off
> > for the "Developer's Certificate of Origin". Hence the Signed-off-by: entry.
> >
> > Is there something wrong with this reasoning?
> 
> Yeah this all makes no sense. If someone submits you a patch for you
> to review *and* push upstream you simply add *their* SOB first, and
> then after that your own.

For my $0.02, having both a Reviewed-by and a Signed-off-by looks
a little funny, but it isn't necessarily wrong.  The Signed-off-by
really only says that you believe that patch is legally contributed.

Oh, and IANAL...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
