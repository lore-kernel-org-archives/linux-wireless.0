Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p02c12o148.mxlogic.net ([208.65.145.81]:53359 "EHLO
	p02c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3BGQek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 11:34:40 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ath9k-devel] Auth Packet TX Delay
Date: Thu, 7 Feb 2013 10:25:57 -0600
Message-ID: <5F3A0E62E0444943B7E4DFE5C598B1154E568B@prodeaserve.prodea.local> (sfid-20130207_173444_859002_1EA21D6D)
In-Reply-To: <CAJ-VmombhTgTaFuQXWR1Q4M8Awg4CwFseDu+iN_U6GfBDUaCig@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com><CAMgrJ3YQ5oua0MJvmVcbb-GuQ8Rr5vwAO3Jy1vs0w-VRRDdcMg@mail.gmail.com><CAJ-VmomnvMqc_0sKvmL-_OQY4cm5xKjqfeWXs_jfUsvFtK9YcQ@mail.gmail.com><CAMgrJ3bvJ-XwBGVcWuUGGyqAoJbjRFZz=om5dsG6MecRAYRO7g@mail.gmail.com><CAJ-VmonzUE9uFN=tDfMXVF-b1Vk3c_+ZTWiGZKPgw8Vnwwadgw@mail.gmail.com><CAMgrJ3ZHRMxzzxf0pj5zc+1TeWkfT2RPwL82JSkTU=AsYnXwfg@mail.gmail.com><CAJ-VmomRvj2hf0i6AMJzCiR42thmTUQ=QCe7FX0k3tw1DTbkoQ@mail.gmail.com><CAMgrJ3YCryn2VvtZJbJSVFUT61TQYPXw+cOXnJQN8Jab-rSuKA@mail.gmail.com><CAMgrJ3b-_a5aBDjAMPChnxEWobnYOhXX3y_FwfNwF75u4hHD6A@mail.gmail.com> <CAJ-VmombhTgTaFuQXWR1Q4M8Awg4CwFseDu+iN_U6GfBDUaCig@mail.gmail.com>
From: "David Littell" <david.littell@prodeasystems.com>
To: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: ath9k-devel-bounces@lists.ath9k.org [mailto:ath9k-devel-
> bounces@lists.ath9k.org] On Behalf Of Adrian Chadd
> Sent: Wednesday, February 06, 2013 11:06 PM
> To: Robert Shade
> Cc: ath9k-devel@lists.ath9k.org; linux-wireless@vger.kernel.org
> Subject: Re: [ath9k-devel] Auth Packet TX Delay
> 
> Okay. Then the radio is truely confused. :-(
> 
> Which chipset is this again?
> 
> 

I'm getting similar behavior using hostapd and an AR5BHB116.  The driver
identifies this as an AR9300 but I've seen "AR9382" associated with
"AR5BHB116" online. (The PCI ID is 168c:0030, for what it's worth.)


Thanks,
Dave




This message is confidential to Prodea Systems, Inc unless otherwise indicated

or apparent from its nature. This message is directed to the intended recipient

only, who may be readily determined by the sender of this message and its

contents. If the reader of this message is not the intended recipient, or an

employee or agent responsible for delivering this message to the intended

recipient:(a)any dissemination or copying of this message is strictly

prohibited; and(b)immediately notify the sender by return message and destroy

any copies of this message in any form(electronic, paper or otherwise) that you

have.The delivery of this message and its information is neither intended to be

nor constitutes a disclosure or waiver of any trade secrets, intellectual

property, attorney work product, or attorney-client communications. The

authority of the individual sending this message to legally bind Prodea Systems 

is neither apparent nor implied,and must be independently verified.
