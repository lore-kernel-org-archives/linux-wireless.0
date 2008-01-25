Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:1624 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756994AbYAYTEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 14:04:37 -0500
Received: by rn-out-0102.google.com with SMTP id i24so259435rng.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2008 11:04:35 -0800 (PST)
Message-ID: <f6ca9fed0801251104m68ebfe45sd9e54a6a20fbb05d@mail.gmail.com> (sfid-20080125_190457_348894_0B9BF178)
Date: Fri, 25 Jan 2008 20:04:35 +0100
From: drago01 <drago01@gmail.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: Re: [ipw3945-devel] iwl3945 rfkill regression
Cc: ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <C07C4589BE74A34981C3C3525EE1F8010338CB51@hasmsx412.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0801221204j71ad2137l19555363e46a7e45@mail.gmail.com>
	 <C07C4589BE74A34981C3C3525EE1F8010338CB35@hasmsx412.ger.corp.intel.com>
	 <f6ca9fed0801221212k709f04dbx1f81cab4c724996a@mail.gmail.com>
	 <C07C4589BE74A34981C3C3525EE1F8010338CB49@hasmsx412.ger.corp.intel.com>
	 <f6ca9fed0801221224u7ddf1569qa29860466ac27d86@mail.gmail.com>
	 <C07C4589BE74A34981C3C3525EE1F8010338CB51@hasmsx412.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 22, 2008 9:29 PM, Winkler, Tomas <tomas.winkler@intel.com> wrote:
>
>
> >-----Original Message-----
> >From: drago01 [mailto:drago01@gmail.com]
>
> >Sent: Tuesday, January 22, 2008 10:24 PM
> >To: Winkler, Tomas
> >Cc: ipw3945-devel; Cahill, Ben M; Zhu, Yi; linux-wireless
> >Subject: Re: [ipw3945-devel] iwl3945 rfkill regression
> >
> >On Jan 22, 2008 9:21 PM, Winkler, Tomas <tomas.winkler@intel.com>
> wrote:
> >>
> >>
> >> >-----Original Message-----
> >> >From: drago01 [mailto:drago01@gmail.com]
> >> >Sent: Tuesday, January 22, 2008 10:12 PM
> >> >To: Winkler, Tomas
> >>
> >> >Cc: ipw3945-devel; Cahill, Ben M; Zhu, Yi; linux-wireless
> >> >Subject: Re: [ipw3945-devel] iwl3945 rfkill regression
> >> >
> >> >On Jan 22, 2008 9:07 PM, Winkler, Tomas <tomas.winkler@intel.com>
> >> wrote:
> >> >>
> >> >> I believe it's delaying uCode load to mac_start - still need to be
> >> >> polished.
> >> >
> >> >ok, thx for the quick reply.
> >> >If you have any potential fixes I would be happy to test them ;)
> >>
> >> Can you get me the sequence it is happening? RF kill switch is off
> >> before you power up the laptop or after, during association or in
> >> unassociated state..etc
> >> Thanks
> >
> >I boot with rf kill off = device on
> >acciotate using NM
> >kill the card by pressing the rfkill (ie. setting it to on)
> >card is dead (like described in my first mail), until I relaod the
> module
> >the rfkill switch  does not have any effect at this time.
>
> Okay thanks, I'll try to look at it tomorrow

Any updates? Can this patch be reerted until the regressions are sorted out?
