Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab1GVN3k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 09:29:40 -0400
Date: Fri, 22 Jul 2011 15:30:34 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, ath9k-devel@venema.h4ckr.net,
	Tony Houghton <h@realh.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	camilo@mesias.co.uk, Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: Re: APSM, AR9285 and bus hangs
Message-ID: <20110722133033.GA2327@redhat.com> (sfid-20110722_152944_010370_E63F3352)
References: <BANLkTikFvkUj=JFrCsffz6Z78KdAEw-t0A@mail.gmail.com>
 <20110613132009.GA7133@redhat.com>
 <BANLkTi=epV40yWe0piXoaDes_F5jOV_DJQ@mail.gmail.com>
 <20110715161857.GA2122@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110715161857.GA2122@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 06:18:58PM +0200, Stanislaw Gruszka wrote:
> On Tue, Jun 14, 2011 at 08:02:54AM +0800, Adrian Chadd wrote:
> > I think the problem on these laptops is that -disabling- the APSM bits
> > causes some systems to hang.
> 
> It is interesting if below patch works, people who can reproduce the
> problem please give it a try. Except testing, I'm also interested
> on comments :-)

I got only feedback from Camilo, patch stops to hung system regularly,
but still there was rare random hangs.

I'm going to post some more patches on linux-wireles mailing list.
Please check them out!

Thanks
Stanislaw
