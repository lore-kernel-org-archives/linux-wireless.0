Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:29278 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYITVJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 17:09:59 -0400
Received: by yx-out-2324.google.com with SMTP id 8so147690yxm.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2008 14:09:57 -0700 (PDT)
Message-ID: <43e72e890809201409h456f189ar2157a1f3167d174f@mail.gmail.com> (sfid-20080920_231003_536216_03269655)
Date: Sat, 20 Sep 2008 14:09:57 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <87abe3mdu4.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <877i98iw4h.fsf@nokia.com>
	 <1221819119.10419.75.camel@johannes.berg> <87abe3mdu4.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey just saw this device supports reporting signal strength in RCPI,
we'll need to add that flag now, or I guess we can keep the dbm as the
software can do the direct mapping. Anyway, cool stuff.

  Luis
