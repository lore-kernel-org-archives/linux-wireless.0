Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49703 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3GaGo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 02:44:26 -0400
Message-ID: <1375253060.8289.1.camel@jlt4.sipsolutions.net> (sfid-20130731_084429_854640_287D0C4E)
Subject: Re: 802.11 infrastructure for regression testing - upstream /
 mac80211 / cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Paul Stewart <pstew@chromium.org>,
	Felix Fietkau <nbd@openwrt.org>, Jouni Malinen <j@w1.fi>
Date: Wed, 31 Jul 2013 08:44:20 +0200
In-Reply-To: <CAB=NE6Vm18RcDYQn+QoEzSG202HezT0rqV_hwb_UOzyecstu5w@mail.gmail.com> (sfid-20130731_025357_256380_141CDEED)
References: <CAB=NE6Vm18RcDYQn+QoEzSG202HezT0rqV_hwb_UOzyecstu5w@mail.gmail.com>
	 (sfid-20130731_025357_256380_141CDEED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-07-30 at 17:53 -0700, Luis R. Rodriguez wrote:
> Folks,
> 
> Back in 2009 Intel had put out a wifi-test tree [0] but that seems
> deprecated now. The git tree at least is gone. Can someone confirm if
> that's dead?

It is indeed dead.

> We later had Google present at the 2010 San Francisco
> wireless summit [1] their test infrastructure using autotest. Last I
> checked that stuff was not merged back upstream to autotest. 

I don't think that's upstream, but it's certainly available as open
source from chromium.

> Can
> someone confirm ? Lastly we have mac80211_hwsim [2] and also a slew of
> internal testing infrastructures that obviously are not open.

hwsim is really orthogonal here - it's a test driver to allow testing in
e.g. virtual machine environments as opposed to a real
testbed/screenroom, but it obviously doesn't provide any test
infrastructure.

johannes

