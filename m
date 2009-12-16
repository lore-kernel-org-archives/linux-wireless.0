Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:55324 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZLPIai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 03:30:38 -0500
Received: by iwn1 with SMTP id 1so536218iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2009 00:30:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200912152352.45977.8an@praha12.net>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
	<200912152156.48074.8an@praha12.net> <20091215215855.GC2067@tux>
	<200912152352.45977.8an@praha12.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 16 Dec 2009 00:30:18 -0800
Message-ID: <43e72e890912160030p3bbca486x817d3454fa9ebd62@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/5] nl80211: Add new WIPHY attribute
	COVERAGE_CLASS
To: 8an@praha12.net
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2009 at 2:52 PM, Lukáš Turek <8an@praha12.net> wrote:

> The problem is, I don't know any hardware that really sends the coverage
> class. There's a lot of hardware that allows setting only the ACK timeout,
> like all the Ubiquity devices, Ovislink 5000 and so on. So the client
> connecting to these devices will need to specify the coverage class manually.

You have a good point here.

> When the coverage class is sent in beacons, it should take precedence over the
> user-specified value, I'm not against that.

OK.

> It's just not relevant now, until
> there's a hardware that sends it or until the hostap part is done. And I said
> I want to do that, just not in this series, it's already problematic
> enough...

OK, yeah you have a good point.

> And about the debugfs: originaly I thought i would just implement a simple
> debugfs API for setting ACK/CTS timeout and slot time. However, Johannes Berg
> recommended me to do this coverage class thing and I didn't envision how much
> trouble it's gonna be...

Thanks a lot for your work on this!

  Luis
