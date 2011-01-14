Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48446 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371Ab1ANSWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 13:22:06 -0500
Message-ID: <4D30944A.30100@openwrt.org>
Date: Fri, 14 Jan 2011 19:22:02 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: Handle interface changes properly
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com> <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com> <4D2E0653.7040606@openwrt.org> <20110113051849.GD8836@vmraj-lnx.users.atheros.com> <4D2F0ADF.1040009@openwrt.org> <20110113163513.GA9291@vmraj-lnx.users.atheros.com> <4D2F2D22.6070301@openwrt.org> <20110114181309.GA11920@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110114181309.GA11920@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-14 7:13 PM, Rajkumar Manoharan wrote:
> On Thu, Jan 13, 2011 at 10:19:38PM +0530, Felix Fietkau wrote:
>>  On 2011-01-13 5:35 PM, Rajkumar Manoharan wrote:
>>  >  Instead of setting opmde as AP for WDS, it is better to handle WDS
>>  >  case in ath9k_hw.
>>  Why? Right now I don't even see any NL80211_IFTYPE_WDS handling in
>>  ath9k_hw, and I can't think of anything that should be handled
>>  differently in ath9k_hw compared to the AP opmode.
> For WDS station, what should be the interface type? Forgive if I'm wrong.
There is no WDS station opmode. 'WDS station' is a regular station 
interface with 4-addr mode enabled. It needs no special handling in ath9k.

- Felix
