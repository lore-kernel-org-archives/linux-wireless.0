Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4453 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbXJZQun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 12:50:43 -0400
Date: Fri, 26 Oct 2007 12:50:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: dragoran <drago01@gmail.com>
Cc: Jes Sorensen <jes@sgi.com>, Dan Williams <dcbw@redhat.com>,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: iwl4965 detection problem
Message-ID: <20071026165012.GE23415@tuxdriver.com> (sfid-20071026_175049_089171_1D1BEA45)
References: <47209C0C.5010505@sgi.com> <1193319925.5542.8.camel@localhost.localdomain> <4720A509.2070708@sgi.com> <1193333545.2111.8.camel@localhost.localdomain> <47219FE6.70900@sgi.com> <20071026123044.GB23415@tuxdriver.com> <4721E17E.2020908@sgi.com> <4721F55F.1030303@sgi.com> <4722051E.8080302@sgi.com> <f6ca9fed0710260823u302cc2cco6dab40100870dbf8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6ca9fed0710260823u302cc2cco6dab40100870dbf8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 26, 2007 at 05:23:50PM +0200, dragoran wrote:
> On 10/26/07, Jes Sorensen <jes@sgi.com> wrote:
> > Jes Sorensen wrote:
> > > I haven't had a chance to build the driver with this change, ie. it's
> > > untested, but I have a suspicion that this patch might do the job.
> >
> > So, tested a kernel with this patch applied, and voila! My wireless
> > now works on first boot!
> >
> > Should I post it to linux-kernel or Andrew or will someone on this list
> > collect it and push it upstream?
> 
> posting it here is enough.
> you should add 3945 repost it in a new thread.

I've got the patch, duped for 3945 as well.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
