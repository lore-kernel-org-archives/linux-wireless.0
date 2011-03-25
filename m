Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30307 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab1CYRJx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 13:09:53 -0400
Subject: Re: [PATCH 01/12] iwlegacy: MAINTAINERS
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20110325161941.GA2493@redhat.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1301062456-17249-2-git-send-email-wey-yi.w.guy@intel.com>
	 <20110325161941.GA2493@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 10:07:29 -0700
Message-ID: <1301072849.9139.8.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, 2011-03-25 at 09:19 -0700, Stanislaw Gruszka wrote:
> On Fri, Mar 25, 2011 at 07:14:05AM -0700, Wey-Yi Guy wrote:
> > Add iwlegacy driver to MAINTAINERS file and mark as 'Orphan'
> I'll take these.
> 
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > ---
> >  MAINTAINERS |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 95482e9..12698b3 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3322,6 +3322,16 @@ F:	Documentation/wimax/README.i2400m
> >  F:	drivers/net/wimax/i2400m/
> >  F:	include/linux/wimax/i2400m.h
> >  
> > +INTEL PRO/WIRELESS 3945ABG/BG NETWORK CONNECTION SUPPORT
> > +L:	linux-wireless@vger.kernel.org
> > +S:	Orphan
> > +F:	drivers/net/wireless/iwlegacy/
> > +
> > +INTEL WIRELESS WIFI 4965AGN NETWORK CONNECTION SUPPORT
> > +L:	linux-wireless@vger.kernel.org
> > +S:	Orphan
> > +F:	drivers/net/wireless/iwlegacy/
> Since path is the same it should be one entry,
> I will post patch soon.
> 
> There are some iwlegacy bugs, which seem to be 2.6.34 -> 2.6.35
> regression. I'm not seeing other way to fix them as moving
> iwlegacy code back to 2.6.34 level. I plan to do this ...
> 
Thank you very much for taking on the responsibilities

Wey


