Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:55855 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab3HEIAH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 04:00:07 -0400
From: Kalle Valo <kvalo@adurom.com>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Ben Greear" <greearb@candelatech.com>,
	"Paul Stewart" <pstew@chromium.org>,
	"Felix Fietkau" <nbd@openwrt.org>, "Jouni Malinen" <j@w1.fi>
Subject: Re: 802.11 infrastructure for regression testing - upstream / mac80211 / cfg80211
References: <CAB=NE6Vm18RcDYQn+QoEzSG202HezT0rqV_hwb_UOzyecstu5w@mail.gmail.com>
	<51F8DA75.8040903@broadcom.com>
Date: Mon, 05 Aug 2013 10:59:43 +0300
In-Reply-To: <51F8DA75.8040903@broadcom.com> (Arend van Spriel's message of
	"Wed, 31 Jul 2013 11:35:49 +0200")
Message-ID: <87li4gwosw.fsf@purkki.adurom.net> (sfid-20130805_100012_336004_3C859A3E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Arend van Spriel" <arend@broadcom.com> writes:

> I am considering coming up with a new test framework for the brcm80211
> drivers using python scripting, which is why I started py80211
> experiment (available on github), but your mentioning of autotest
> makes me want to revisit that.

No no, please forget anything your heard about autotest and just focus
on py80211 ;)

More seriously, my experience with the autotest and any other test
frameworks are that they are so freaking huge and difficult to maintain
that eventually they just die. Small is beautiful and I have been
dreaming about a lean and mean python based nl80211 test harness for
drivers, but never found the time to do anything (my usual story). So
I'm eagerly waiting how your py80211 will workout.

-- 
Kalle Valo
