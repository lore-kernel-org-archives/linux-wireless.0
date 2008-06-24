Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44455 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYFXLMp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 07:12:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH 4/4] mac80211: add phy information to giwname
Date: Tue, 24 Jun 2008 13:08:09 +0200
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com> <200806241242.11727.mb@bu3sch.de> <1ba2fa240806240354n45c144a3n5ac8b08c7da7b7a2@mail.gmail.com>
In-Reply-To: <1ba2fa240806240354n45c144a3n5ac8b08c7da7b7a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806241308.09404.mb@bu3sch.de> (sfid-20080624_131247_339070_EF309A5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 June 2008 12:54:25 Tomas Winkler wrote:
> See the log message...(known issue). Currently you have to loop over
> rates to get this info. I wasn't sure if they are any b-only NICs
> under mac80211 so I didn't run to implement it.

b43legacy.
I'd say we either implement it correctly or not at all.
Everything else will only confuse users and generate useless noise
on the lists.

-- 
Greetings Michael.
