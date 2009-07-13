Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30720 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbZGMVmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 17:42:15 -0400
Subject: Re: [ipw3945-devel] iwlwifi 4965 uCode available
From: reinette chatre <reinette.chatre@intel.com>
To: John Ranson <ranson@analager.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <bcd1ba70907131252x3d9e21bbx80241aba1edff5ba@mail.gmail.com>
References: <1247174482.17896.1304.camel@rc-desk>
	 <200907121445.42289.helmut.schaa@gmail.com>
	 <1247499979.17896.1556.camel@rc-desk>
	 <bcd1ba70907131143m2940444ch372ae0bc01417bc4@mail.gmail.com>
	 <1247511400.17896.1625.camel@rc-desk>
	 <bcd1ba70907131252x3d9e21bbx80241aba1edff5ba@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 14:42:14 -0700
Message-Id: <1247521334.17896.1683.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi John,

On Mon, 2009-07-13 at 12:52 -0700, John Ranson wrote:
> Reinette,
> 
> On Mon, Jul 13, 2009 at 11:56 AM, reinette
> chatre<reinette.chatre@intel.com> wrote:
> > John,
> >
> > On Mon, 2009-07-13 at 11:43 -0700, John Ranson wrote:
> >> I am also seeing frequent loss of association and firmware restarts
> >> with the new firmware.  On occasion, I can't recover even when I
> >> reload the driver. Admittedly, I am using an old driver right now
> >> (2.6.29, I think).
> >
> > The better restart work was added in 2.6.31 I think, so it is only in
> > the recent driver that you will have a smooth recovery after a failure.
> > You may thus be seeing the same problem as Helmut, with him running the
> > recent restart code.
> 
> Can I also get this with the latest compat wireless release and
> 2.6.30.1? I don't usually switch to a new kernel until it's been
> stable for a while.

yes - compat wireless contains all the latest code, which includes this
restart work.

> 
> >
> >>
> >> I'm going to upgrade to 2.6.30.1 with the latest compat-wireless. I'll
> >> file a bug if things continue as they are.
> >
> > Even if the restart code gets you up and running smoothly after a
> > failure, please do submit a bug report so that we can look into this.
> 
> I'll be sure to file a bug.

Thank you very much

Reinette


