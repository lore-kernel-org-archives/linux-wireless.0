Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab2DPWXV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:23:21 -0400
Message-ID: <1334614996.5455.30.camel@dcbw.foobar.com> (sfid-20120417_002324_752352_1D40F2DC)
Subject: Re: [RFC 4/4] libertas SDIO: convert to asynchronous firmware
 loading
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Date: Mon, 16 Apr 2012 17:23:16 -0500
In-Reply-To: <CAMLZHHQ02Y0s7O4t7jKZZ+1H8SiyPGYxwLhdVHYSuf5aUA0fqw@mail.gmail.com>
References: <20120403160319.B26CF9D401E@zog.reactivated.net>
	 <1334612679.5455.4.camel@dcbw.foobar.com>
	 <CAMLZHHQ02Y0s7O4t7jKZZ+1H8SiyPGYxwLhdVHYSuf5aUA0fqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-16 at 15:55 -0600, Daniel Drake wrote:
> On Mon, Apr 16, 2012 at 3:44 PM, Dan Williams <dcbw@redhat.com> wrote:
> > On Tue, 2012-04-03 at 17:03 +0100, Daniel Drake wrote:
> >> Signed-off-by: Daniel Drake <dsd@laptop.org>
> >
> > Works on my standalone SD8686 dev board; though I do get:
> >
> > [32350.237619] libertas_sdio mmc0:0001:1: (unregistered net_device):
> > 00:50:43:20:74:05, fw 9.70.3p36, cap 0x00000303
> > [32350.239847] libertas_sdio mmc0:0001:1: (unregistered net_device):
> > PREP_CMD: command 0x00a3 failed: 2
> >
> > where the "unregistered net_device" is a bit odd.  Perhaps we should fix
> > that before the final series.
> 
> That actually appears the same before the patches too, it's been this
> way ever since the cfg80211 port. Mind if I leave this issue for
> another moment?

I have no problem with that.

Dan

