Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57191 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1LKDh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 22:37:27 -0500
Received: by ghbf1 with SMTP id f1so266308ghb.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 19:37:26 -0800 (PST)
Message-ID: <4EE42574.1030606@lwfinger.net> (sfid-20111211_043738_823916_C7B0F774)
Date: Sat, 10 Dec 2011 21:37:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/7] b43: N-PHY fixes, check dependency before applying
References: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał,

I checked the network traffic on the 43224 using kismet. The beacons are clearly 
seen in the capture; however, they appear not to get back to mac80211. I'll look 
for the reason.

Larry



