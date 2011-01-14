Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37093 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780Ab1ANSyF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 13:54:05 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 10:53:46 -0800
Date: Sat, 15 Jan 2011 00:23:18 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: Handle interface changes properly
Message-ID: <20110114185317.GA12051@vmraj-lnx.users.atheros.com>
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
 <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
 <4D2E0653.7040606@openwrt.org>
 <20110113051849.GD8836@vmraj-lnx.users.atheros.com>
 <4D2F0ADF.1040009@openwrt.org>
 <20110113163513.GA9291@vmraj-lnx.users.atheros.com>
 <4D2F2D22.6070301@openwrt.org>
 <20110114181309.GA11920@vmraj-lnx.users.atheros.com>
 <4D30944A.30100@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4D30944A.30100@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 14, 2011 at 11:52:02PM +0530, Felix Fietkau wrote:
> On 2011-01-14 7:13 PM, Rajkumar Manoharan wrote:
> > On Thu, Jan 13, 2011 at 10:19:38PM +0530, Felix Fietkau wrote:
> >>  On 2011-01-13 5:35 PM, Rajkumar Manoharan wrote:
> >>  >  Instead of setting opmde as AP for WDS, it is better to handle WDS
> >>  >  case in ath9k_hw.
> >>  Why? Right now I don't even see any NL80211_IFTYPE_WDS handling in
> >>  ath9k_hw, and I can't think of anything that should be handled
> >>  differently in ath9k_hw compared to the AP opmode.
> > For WDS station, what should be the interface type? Forgive if I'm wrong.
> There is no WDS station opmode. 'WDS station' is a regular station 
> interface with 4-addr mode enabled. It needs no special handling in ath9k.
still not convinced. Then what is the point mac80211 is informing about
WDS type to drivers. mac itself can pass it as AP type like what it 
is doing for p2p GO.

--
Rajkumar
