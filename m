Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:60055 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab3GaAxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 20:53:53 -0400
Received: by mail-la0-f50.google.com with SMTP id fn20so55236lab.23
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2013 17:53:52 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 30 Jul 2013 17:53:31 -0700
Message-ID: <CAB=NE6Vm18RcDYQn+QoEzSG202HezT0rqV_hwb_UOzyecstu5w@mail.gmail.com> (sfid-20130731_025357_256380_141CDEED)
Subject: 802.11 infrastructure for regression testing - upstream / mac80211 / cfg80211
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ben Greear <greearb@candelatech.com>,
	Paul Stewart <pstew@chromium.org>,
	Felix Fietkau <nbd@openwrt.org>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Folks,

Back in 2009 Intel had put out a wifi-test tree [0] but that seems
deprecated now. The git tree at least is gone. Can someone confirm if
that's dead? We later had Google present at the 2010 San Francisco
wireless summit [1] their test infrastructure using autotest. Last I
checked that stuff was not merged back upstream to autotest. Can
someone confirm ? Lastly we have mac80211_hwsim [2] and also a slew of
internal testing infrastructures that obviously are not open.

If we are to embark on a new journey towards an open testing
infrastructure what should be used? Ben, you have some stuff, and I
know you also report some interesting bugs with insane amount of
stations. Is any of it open?

AFAICT mac80211_hwism should and likely already is used for a slew of
core API changes / tests. Addressing testing using that shoud
hopefully address tons of testings and find a lot of issues. We'd then
just need vendors to replicate behaviour on top of their drivers. The
core test stuff though still needs to be available.

What do we have, anyone have any lofty plans?

[0] http://wireless.kernel.org/en/developers/Testing/wifi-test
[1] http://wireless.kernel.org/en/developers/Summits/SanFranciscoBayArea-2010
[2] http://wireless.kernel.org/en/users/Drivers/mac80211_hwsim

  Luis
