Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36008 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbbFKN1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 09:27:20 -0400
Message-ID: <1434029236.1915.13.camel@sipsolutions.net> (sfid-20150611_152725_515548_48A698E3)
Subject: Re: Exposing enum ieee80211_channel_flags to user
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 11 Jun 2015 15:27:16 +0200
In-Reply-To: <55798A2C.7070300@candelatech.com>
References: <CACna6rwHXzGTZ+NS9PpZENJATVzRzm1Wkija0_CrveMoM05d5g@mail.gmail.com>
		 <1434015922.1915.6.camel@sipsolutions.net>
		 <1434016002.1915.7.camel@sipsolutions.net>
		 <CACna6ry_VRbUbEQeVXC5j68VzPOkJ-qOsAGzKN8XswhHXnO+tw@mail.gmail.com>
		 (sfid-20150611_120017_614164_3F327AEA) <1434016900.1915.8.camel@sipsolutions.net>
	 <55798A2C.7070300@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-11 at 06:16 -0700, Ben Greear wrote:

> Maybe also allow the full dump with an optional --verbose flag:  'iw --verbose phy X info' ?

Well, as I said, it's not so simple to do this in the "info" handler
since you need to collect all the info first and then print it.

johannes

