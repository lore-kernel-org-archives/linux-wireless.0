Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2KRLFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2012 06:05:00 -0500
Message-ID: <1353236729.9649.4.camel@jlt4.sipsolutions.net> (sfid-20121118_120508_533064_80E98D0A)
Subject: Re: VHT support, take 2
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Mahesh Palivela <maheshp@posedge.com>,
	linux-wireless@vger.kernel.org, green@qca.qualcomm.com,
	dquan@qca.qualcomm.com
Date: Sun, 18 Nov 2012 12:05:29 +0100
In-Reply-To: <1353236622.9649.2.camel@jlt4.sipsolutions.net> (sfid-20121118_120327_588286_11CD74EA)
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
	 <1352492493.28302.7.camel@jlt4.sipsolutions.net>
	 <50A4DB80.2020209@posedge.com>
	 <1353072509.9490.7.camel@jlt4.sipsolutions.net>
	 <50A65443.2000101@broadcom.com>
	 <20121117001046.GP3354@lenteja.do-not-panic.com>
	 <1353142108.9543.4.camel@jlt4.sipsolutions.net>
	 <20121117233409.GT3354@lenteja.do-not-panic.com>
	 <1353236622.9649.2.camel@jlt4.sipsolutions.net>
	 (sfid-20121118_120327_588286_11CD74EA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-11-18 at 12:03 +0100, Johannes Berg wrote:
> On Sat, 2012-11-17 at 15:34 -0800, Luis R. Rodriguez wrote:
> 
> > > > The only thing mentioned which I had not considered is the per bandwidth
> > > > TX power restrictions. Where did these come from ?
> > > 
> > > As usual, they come from the regulations :-)
> > 
> > Which one in particular decided to add per bandwidth
> > TX power restrictions for VHT ?
> 
> German regulations have always had bandwidth restrictions, we've just
> fuzzed around it by restricting it to the lowest common power between 20
> and 40 MHz bandwidth.

I should add: with VHT coming with 160 MHz channels, I don't think we
can continue to work around it that way as that would be really
limiting.

johannes

