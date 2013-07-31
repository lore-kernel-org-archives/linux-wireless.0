Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60202 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3GaSNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 14:13:24 -0400
Message-ID: <51F953BB.6050205@candelatech.com> (sfid-20130731_201327_287494_B5E801CE)
Date: Wed, 31 Jul 2013 11:13:15 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@chromium.org>,
	Felix Fietkau <nbd@openwrt.org>, Jouni Malinen <j@w1.fi>
Subject: Re: 802.11 infrastructure for regression testing - upstream / mac80211
 / cfg80211
References: <CAB=NE6Vm18RcDYQn+QoEzSG202HezT0rqV_hwb_UOzyecstu5w@mail.gmail.com>
In-Reply-To: <CAB=NE6Vm18RcDYQn+QoEzSG202HezT0rqV_hwb_UOzyecstu5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/30/2013 05:53 PM, Luis R. Rodriguez wrote:
> Folks,
>
> Back in 2009 Intel had put out a wifi-test tree [0] but that seems
> deprecated now. The git tree at least is gone. Can someone confirm if
> that's dead? We later had Google present at the 2010 San Francisco
> wireless summit [1] their test infrastructure using autotest. Last I
> checked that stuff was not merged back upstream to autotest. Can
> someone confirm ? Lastly we have mac80211_hwsim [2] and also a slew of
> internal testing infrastructures that obviously are not open.
>
> If we are to embark on a new journey towards an open testing
> infrastructure what should be used? Ben, you have some stuff, and I
> know you also report some interesting bugs with insane amount of
> stations. Is any of it open?

Our user-space app is not open.  I'm happy to offer free licenses
for good causes, but I understand that is probably not so interesting to most
folks.

Our stuff only really works with ath9k (and possibly ath5k).  Might
work in the future with ath10k if we can get the firmware and other
limitations resolved.  And, maybe some other vendors will start
supporting lots of virtual stations..but I don't know of any others
at this time.

At the least, we'll keep running our internal testing & dev efforts
and will continue to report strange bugs :)

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


