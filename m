Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18452 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1HITXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 15:23:13 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Pavel Roskin <proski@gnu.org>,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 9 Aug 2011 22:23:04 +0300
Subject: RE: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv
 pointer
Message-ID: <4825B8A2C4E264489E57869F0DCFB22344564F65AF@hasmsx502.ger.corp.intel.com> (sfid-20110809_212317_088147_1A45CD21)
References: <1312228017-12061-1-git-send-email-wey-yi.w.guy@intel.com>
	<CALSq=BYkKhJN=GU0RUJ2viibsy5yG78x-D-td0zP+rqWCy=AiQ@mail.gmail.com>
	<4825B8A2C4E264489E57869F0DCFB22344563F4ABE@hasmsx502.ger.corp.intel.com>
	<CALSq=BZ2CoF=+Zw-si5oc8No9MLTP1YoZCzfoT9TX1XEaLnq1A@mail.gmail.com>
	<CALSq=BYY8-fAqATwJaFNvzwpSo4WWXbH=pRXn0oknqKXH=4X2A@mail.gmail.com>
	<1312499702.15170.17.camel@wwguy-huron>	<20110805225051.435fe1b0@mj>
	<E9954878DD1FB34FAE5187FB88C58A350199604D92@orsmsx506.amr.corp.intel.com>
	<CANUX_P3p3mqUjJrynivna5Fu4iv8DDdH-rY53Y36tHRVewSSuQ@mail.gmail.com>
 <CAD2nsn105hyUW0WjN-iggdorxk0wsm7r1EHzN1-MeaMjovQG5A@mail.gmail.com>
In-Reply-To: <CAD2nsn105hyUW0WjN-iggdorxk0wsm7r1EHzN1-MeaMjovQG5A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Sun, Aug 7, 2011 at 1:13 AM, Emmanuel Grumbach <egrumbach@gmail.com>
> wrote:
> > Can you please try that one ?
> > I don't have my machine near me, and don't want to crash it remotely,
> > so I didn't test it. I will test in on Sunday.
> 
> Hi Emmanuel,
> 
> I also got the same kernel panic when unloading the iwlagn module for
> my inbuilt laptop card and i tried the attached patch and it seems to
> fix it.
> 
> 
Hi Mohammed,

Thanks for your time testing it.
The final fix will be sent through the regular channel very soon.

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

