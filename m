Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11788 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab3HUFqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 01:46:30 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Greg KH <greg@kroah.com>, Emmanuel Grumbach <egrumbach@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 3.10 0/3] Enable 7000 device family on 3.10
Date: Wed, 21 Aug 2013 05:46:22 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301A3C83B@HASMSX103.ger.corp.intel.com> (sfid-20130821_074634_281670_0671C456)
References: <1373888700-3040-1-git-send-email-emmanuel.grumbach@intel.com>
 <20130802090234.GA20470@kroah.com>
 <1375792779.8219.16.camel@jlt4.sipsolutions.net>
 <20130806134218.GB525@kroah.com>
 <CANUX_P0BxGr9coDjOmHJm+8kVJVsM9XiTDTVsb_kysuRmcmpNw@mail.gmail.com>
 <20130820212524.GA9902@kroah.com>
In-Reply-To: <20130820212524.GA9902@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, Aug 20, 2013 at 11:22:21PM +0300, Emmanuel Grumbach wrote:
> > On Tue, Aug 6, 2013 at 4:42 PM, Greg KH <greg@kroah.com> wrote:
> > > On Tue, Aug 06, 2013 at 02:39:39PM +0200, Johannes Berg wrote:
> > >> [Emmanuel is on vacation, I'll cover for him]
> > >>
> > >> On Fri, 2013-08-02 at 17:02 +0800, Greg KH wrote:
> > >> > On Mon, Jul 15, 2013 at 02:44:57PM +0300, Emmanuel Grumbach
> wrote:
> > >> > > This small patch series enables 7260 and 3160 devices on 3.10
> > >> > > kernel. Three patches are already in linux.git (3.11-rc1).
> > >> > > One patch is 3.10 specific and disables configuration that is
> > >> > > not supported in 3.10.
> > >> >
> > >> > I need the git commit id of these patches in Linus's tree before
> > >> > I can apply them.  Please resend them with that information.
> > >>
> > >> The second and third patch does have it, and the first patch is
> > >> only relevant for 3.10 since 3.11 will have more device types
> > >> enabled, we just didn't get all the code in. This seems to be
> > >> described in the commit log, do you want more details?
> > >
> > > Yes, please resend them with those details.  For me to take a patch
> > > that is not in Linus's tree is a big deal, I need a whole lot of
> > > justification for it.
> > >
> >
> > Just got back. Sorry for the delay.
> > I guess I will just drop that patch that is not in Linus's tree.
> > This patch disables a feature that is not likely to be used but we
> > *know* it is buggy.
> > So people who want more than just associating to their router will see
> > a bug in 3.10.
> > I guess we can leave with that since I was suggesting to disable the
> > feature anyway.
> 
> Why would this patch not go to Linus's tree?  If it's broken, fix it, and I can
> take the backported patch into the 3.10 tree.

It is actually a few patches and they are already in Linus's tree.
Sending them to you.

> 
> > So - do you want to resend, or you can apply the 2 patches I sent as is?
> 
> Please resend.
> 

On the way.
