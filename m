Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:55401 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139Ab1CRRRq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 13:17:46 -0400
Date: Fri, 18 Mar 2011 17:56:26 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Juan Carlos Garza <juancarlosgarza@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers
 in AP and IBSS
Message-ID: <20110318165626.GA12889@sig21.net>
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
 <201103172107.25316.helmut.schaa@googlemail.com>
 <AANLkTi=u3dw1D1-+-Cy9aEPc2H1MAF+cUi=ucvMTNrNc@mail.gmail.com>
 <201103181642.28386.helmut.schaa@googlemail.com>
 <AANLkTi=oAQ1M=XmFpyjh+2zkHidN_AdG7880A=TGsM-h@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=oAQ1M=XmFpyjh+2zkHidN_AdG7880A=TGsM-h@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,

On Fri, Mar 18, 2011 at 05:15:04PM +0100, Ivo Van Doorn wrote:
> On Fri, Mar 18, 2011 at 4:42 PM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
> > Thanks for testing Juan.
> >
> > Am Freitag, 18. März 2011 schrieb Juan Carlos Garza:
> >> I applied the patches (manually), and tested the stick.
> >>
> >> The transfer of big loads now is successful.
> >
> > Ivo, Johannes, are there any issues left with the async tx status
> > patches for rt2800usb (in the experimental branch) as they seem to
> > lower the chance for missed tx status reports.
> 
> I have to do a performance test to see if there are any issues remaining,
> but so far all those patches resulted in poorer performance (reduced
> association successes).

IIRC you did no report any newer test results after
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/003070.html
(I think this change was merged into one of the other patches in rt2x00/experimental)

For me association works fast and reliable with these patches, but I
did not have time to test with the wpa_supplicant from
your ros.org code base.

Without the fix above it is clear why association would be unreliable.


Johannes
