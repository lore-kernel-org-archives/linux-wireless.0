Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35534 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840AbaIIQuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 12:50:18 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by gateway2.nyi.internal (Postfix) with ESMTP id F2865210B8
	for <linux-wireless@vger.kernel.org>; Tue,  9 Sep 2014 12:50:16 -0400 (EDT)
Message-Id: <1410281416.2770593.165489213.019D33E6@webmail.messagingengine.com> (sfid-20140909_185022_527895_B5718C19)
From: Thomas Pedersen <thomas@noack.us>
To: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>
Cc: chandrika parimoo <chandrika3437@gmail.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: Mesh Support in brcmsmac
Date: Tue, 09 Sep 2014 09:50:16 -0700
In-Reply-To: <20140909132623.GD29412@tuxdriver.com>
References: <CACHGq=AYtyCh2s_h_UtBtnH4TdHuw+gHeXhKjT2kVQSLcBSrow@mail.gmail.com>
 <540ED666.9070101@broadcom.com> <20140909132623.GD29412@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2014, at 06:26 AM, John W. Linville wrote:
> On Tue, Sep 09, 2014 at 12:28:54PM +0200, Arend van Spriel wrote:
> > + linux-wireless
> > 
> > On 09/09/14 12:22, chandrika parimoo wrote:
> > >Hello,
> > >
> > >I have broadcom bcm4313 card and am using brcmsmac driver which does not
> > >have mesh support currently.
> > >I wanted to know if there is a workaround for it?
> > 
> > No workaround. I am not familiar with wireless mesh networking. I suppose
> > there are people on the linux-wireless mailing list who know what is needed
> > from a mac80211 driver (like brcmsmac) to enable mesh networking.
> 
> The main things is the beacons, no?

Yeah mainly beacons, but also 4addr frames and FIF_OTHER_BSS filter.

--
thomas
