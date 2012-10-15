Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab2JOPiw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 11:38:52 -0400
Date: Mon, 15 Oct 2012 17:37:53 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: Lots of trans->state != IWL_TRANS_FW_ALIVE warnings
Message-ID: <20121015153752.GE12560@redhat.com> (sfid-20121015_173855_787425_AFE0250F)
References: <20121015144722.GA12560@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB3B7D4BB@HASMSX106.ger.corp.intel.com>
 <20121015152336.GC12560@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121015152336.GC12560@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 15, 2012 at 05:23:36PM +0200, Stanislaw Gruszka wrote:
> On Mon, Oct 15, 2012 at 03:14:51PM +0000, Grumbach, Emmanuel wrote:
> > > I glanced at the bugs and I can only see the trace dump. I am pretty sure
> > > there is an issue before the dump - fw assert of something like that. Can it be
> > > possible to get the full log?
> > > 
> > 
> > Can you ask people to try the attached patch?
> > This will let us know where the fw is brought down.
> 
> Yes, I'll build kernel with that patch and request for test and dmesg.

debug=0x400 is enough or do you want also some other flags?

Stanislaw
