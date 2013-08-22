Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35107 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3HVOBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 10:01:08 -0400
Message-ID: <1377180063.14110.23.camel@jlt4.sipsolutions.net> (sfid-20130822_160112_230405_66986B2E)
Subject: Re: [PATCH] mac80211: ignore obviously bogus ECSAs in probe
 response frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 22 Aug 2013 16:01:03 +0200
In-Reply-To: <1377179613-26591-1-git-send-email-seth.forshee@canonical.com> (sfid-20130822_155337_522772_AB94433A)
References: <1377179613-26591-1-git-send-email-seth.forshee@canonical.com>
	 (sfid-20130822_155337_522772_AB94433A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-22 at 08:53 -0500, Seth Forshee wrote:
> The Netgear WNDAP360 sends invalid ECSA IEs in probe response
> frames

I think we shouldn't be checking probe response frames at all. That
seems like a mistake. Can you try this?

http://p.sipsolutions.net/015f7b799f19426a.txt

johannes


