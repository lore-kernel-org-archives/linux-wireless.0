Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2579 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbbLOHyo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 02:54:44 -0500
From: David Lin <dlin@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>, Pete Hsieh <peteh@marvell.com>
Subject: RE: [PATCH v7] Add new mac80211 driver mwlwifi.
Date: Tue, 15 Dec 2015 07:54:39 +0000
Message-ID: <492141d5bea0408b92aa8a53e53c24d3@SC-EXCH02.marvell.com> (sfid-20151215_085447_594961_E43A2445)
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
	<1448018530.3141.25.camel@sipsolutions.net>
	<097ef0472294430d98940ad601a4aade@SC-EXCH02.marvell.com>
	<1448530804.2167.4.camel@sipsolutions.net>
	<9d111cc7d61047b5890b7c5d53d71bbd@SC-EXCH02.marvell.com>
 <87d1ue73m0.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87d1ue73m0.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Kalle Valo [mailto:kvalo@codeaurora.org] wrote:
> 
> David Lin <dlin@marvell.com> writes:
> 
> > On November 26, 2015 5:40 PM, Johannes Berg wrote:
> >> On Thu, 2015-11-26 at 08:27 +0000, David Lin wrote:
> >>
> >> > > > +#ifdef CONFIG_SUPPORT_MFG
> >> > >
> >> > > This Kconfig variable doesn't exist.
> >> > >
> >> >
> >> > The compile variable is used privately by Marvell and our customers
> >> > in production line.
> >>
> >> Yeah, still. Make it a proper Kconfig variable, defaulting to off and
> >> hidden under something, or remove it. It's extremely misleading to
> >> have something called CONFIG_* when it's not a Kconfig variable.
> >>
> >
> > I will change this compile variable from "CONFIG_SUPPORT_MFG" to
> > "SUPPORT_MFG".
> 
> Then it's still dead code which won't ever get compiled in upstream.
> Please follow what Johannes suggested.
> 

The code will be removed.

> --
> Kalle Valo
