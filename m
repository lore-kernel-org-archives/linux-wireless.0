Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64063 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab1HHQTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 12:19:35 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 8 Aug 2011 19:19:29 +0300
Subject: RE: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv
 pointer
Message-ID: <4825B8A2C4E264489E57869F0DCFB22344564F5D8D@hasmsx502.ger.corp.intel.com> (sfid-20110808_181938_879970_9535BAAB)
References: <CALSq=BYkKhJN=GU0RUJ2viibsy5yG78x-D-td0zP+rqWCy=AiQ@mail.gmail.com>
 <4825B8A2C4E264489E57869F0DCFB22344563F4ABE@hasmsx502.ger.corp.intel.com>
 <CALSq=BZ2CoF=+Zw-si5oc8No9MLTP1YoZCzfoT9TX1XEaLnq1A@mail.gmail.com>
 <CALSq=BYY8-fAqATwJaFNvzwpSo4WWXbH=pRXn0oknqKXH=4X2A@mail.gmail.com>
 <1312499702.15170.17.camel@wwguy-huron> <20110805225051.435fe1b0@mj>
 <E9954878DD1FB34FAE5187FB88C58A350199604D92@orsmsx506.amr.corp.intel.com>
 <CANUX_P3p3mqUjJrynivna5Fu4iv8DDdH-rY53Y36tHRVewSSuQ@mail.gmail.com>
 <4825B8A2C4E264489E57869F0DCFB22344564A2C19@hasmsx502.ger.corp.intel.com>
 <E9954878DD1FB34FAE5187FB88C58A350199604E03@orsmsx506.amr.corp.intel.com>
 <20110808142744.GA21103@tuxdriver.com>
In-Reply-To: <20110808142744.GA21103@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Sure, that sounds great.

Ok, I am OOO tomorrow, so it will wait until Wednesday.


> 
> On Sat, Aug 06, 2011 at 11:21:42PM -0700, Guy, Wey-Yi W wrote:
> > I will like to combine the patches if it's ok for John.
> >
> > Wey
> >
> > -----Original Message-----
> > From: Grumbach, Emmanuel
> > Sent: Sunday, August 07, 2011 8:09 AM
> > To: Grumbach, Emmanuel; Emmanuel Grumbach; Guy, Wey-Yi W
> > Cc: Pavel Roskin; Daniel Halperin; linville@tuxdriver.com; linux-
> wireless@vger.kernel.org
> > Subject: RE: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv
> pointer
> >
> > FWIW, the patch below solved the problem on my system.
> > Dan, please confirm you are happy with it.
> >
> > The bug was introduced by the patch that fixed the sysfs issue.
> >
> > Wey, John, do you think it would be better to revert my previous fix and
> send a combined patch that solves the sysfs issue and doesn't add the bug ?
> Or another patch on top of the buggy sysfs fix ?
> >
> > Thanks,
> >        Emmanuel
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

