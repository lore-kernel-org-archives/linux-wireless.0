Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55638 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab2JOSxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 14:53:34 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: RE: Lots of trans->state != IWL_TRANS_FW_ALIVE warnings
Date: Mon, 15 Oct 2012 18:53:05 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3B7D5A6@HASMSX106.ger.corp.intel.com> (sfid-20121015_205337_499018_4AF01BCD)
References: <20121015144722.GA12560@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB3B7D4BB@HASMSX106.ger.corp.intel.com>
 <20121015152336.GC12560@redhat.com> <20121015153752.GE12560@redhat.com>
In-Reply-To: <20121015153752.GE12560@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Mon, Oct 15, 2012 at 05:23:36PM +0200, Stanislaw Gruszka wrote:
> > On Mon, Oct 15, 2012 at 03:14:51PM +0000, Grumbach, Emmanuel wrote:
> > > > I glanced at the bugs and I can only see the trace dump. I am
> > > > pretty sure there is an issue before the dump - fw assert of
> > > > something like that. Can it be possible to get the full log?
> > > >
> > >
> > > Can you ask people to try the attached patch?
> > > This will let us know where the fw is brought down.
> >
> > Yes, I'll build kernel with that patch and request for test and dmesg.
> 
> debug=0x400 is enough or do you want also some other flags?
> 
0x400 should be enough, but 0x403 would be better :-)
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

