Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:36290 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3JNRt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 13:49:59 -0400
Received: by mail-oa0-f52.google.com with SMTP id n2so4674270oag.25
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 10:49:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381772716.13092.21.camel@jlt4.sipsolutions.net>
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
	<1381516190-23918-4-git-send-email-yeohchunyeow@cozybit.com>
	<1381760191.13092.13.camel@jlt4.sipsolutions.net>
	<CAHS2MGMONy37xZedzRhx10Mes9MCUMfiEjmWjprVOEQY_brw9Q@mail.gmail.com>
	<1381772716.13092.21.camel@jlt4.sipsolutions.net>
Date: Tue, 15 Oct 2013 01:49:59 +0800
Message-ID: <CAHS2MGNwG-_kSLAVrULAX1TxkfPYW=Ru23=Jq=9im1i+ZW7pNA@mail.gmail.com> (sfid-20131014_195002_920347_E6164F8F)
Subject: Re: [PATCH v4 3/6] mac80211: add the CSA and MCSP elements in mesh beaconing
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It occurs after later patches only though, and this patch introduces an
> RCU warning. I'd suggest to roll this into patch 5 or so since there
> it's really only used?
It make sense. I will do that.

----
Chun-Yeow
