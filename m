Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:40882 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbYKEQDU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 11:03:20 -0500
Received: by yx-out-2324.google.com with SMTP id 8so33629yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 08:03:19 -0800 (PST)
Message-ID: <b6c5339f0811050803j73079462vcc5a1def97879f0b@mail.gmail.com> (sfid-20081105_170323_922256_35D94A82)
Date: Wed, 5 Nov 2008 11:03:18 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] ath5k: enable RXing beacons
Cc: "Dan Williams" <dcbw@redhat.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
In-Reply-To: <43e72e890811041119w57fd838ex84c9b18f3dd3ba23@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225672612-15106-1-git-send-email-lrodriguez@atheros.com>
	 <1225676353.13684.2.camel@localhost.localdomain>
	 <b6c5339f0811021810w229d1d9al2b27bdf4144cde69@mail.gmail.com>
	 <43e72e890811022043t5525d924vcb776569a7bebbc8@mail.gmail.com>
	 <43e72e890811022049l386789f5qf8bde98eedcd4d2c@mail.gmail.com>
	 <43e72e890811022052n8c5e7d3ic722caa65c711481@mail.gmail.com>
	 <b6c5339f0811030717mfa8ac56hdd58c367563ed931@mail.gmail.com>
	 <b6c5339f0811040437h4da7f3a1v3b606145c0702243@mail.gmail.com>
	 <43e72e890811041119w57fd838ex84c9b18f3dd3ba23@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 4, 2008 at 2:19 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> get some strange internal mode checks as we do now. I posted a
> strategy we can take in the other thread to handle the beacon filter
> in mac80211, let me know what you think.

Yup, it sounds reasonable.  It would definitely be nice to be able to
drop the mode checks in the drivers' configure_filter callbacks.

-- 
Bob Copeland %% www.bobcopeland.com
