Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53689 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752270AbXLKVyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 16:54:10 -0500
Subject: Re: [PATCH 2/4] iwlwifi: Update to changed mac80211 rate control
	interface
From: Mattias Nissler <mattias.nissler@gmx.de>
To: mohamed salim abbas <mabbaswireless@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <b3153e950712111310r7f527068j7997bdceaee3488@mail.gmail.com>
References: <1197112439.7472.34.camel@localhost>
	 <1197112911.7472.50.camel@localhost> <20071208141953.1233aa30@morte>
	 <b3153e950712111310r7f527068j7997bdceaee3488@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 22:54:06 +0100
Message-Id: <1197410046.7030.2.camel@localhost> (sfid-20071211_215415_361910_2BA2F271)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-12-11 at 13:10 -0800, mohamed salim abbas wrote:
> for any non data frame we should use the lowest rate. the firmware
> might not like it if higher rate been used. I just checked out latest
> of mac80211 the rate scaling functions have not changed with this
> patch it wont work.

Note that the patch shouldn't change iwlwifi's rate control behaviour.
So if it breaks iwlwifi, I have a bug in my patch. Have you applied the
complete patchset? The selection of the lowest rate for non-data frames
is moved into mac80211 in the first patch of the series.

Mattias

