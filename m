Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:65505 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbYFXOGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 10:06:06 -0400
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Michael Buesch" <mb@bu3sch.de>, linville@tuxdriver.com,
	johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] mac80211: add phy information to giwname
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	<1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
	<1214303881-31525-5-git-send-email-tomas.winkler@intel.com>
	<200806241242.11727.mb@bu3sch.de>
	<1ba2fa240806240354n45c144a3n5ac8b08c7da7b7a2@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 24 Jun 2008 17:03:49 +0300
In-Reply-To: <1ba2fa240806240354n45c144a3n5ac8b08c7da7b7a2@mail.gmail.com> (ext Tomas Winkler's message of "Tue\, 24 Jun 2008 13\:54\:25 +0300")
Message-ID: <87vdzzdj5m.fsf@nokia.com> (sfid-20080624_160610_354859_13D425D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

>> What about b-only devices?
>
> See the log message...(known issue). Currently you have to loop over
> rates to get this info. I wasn't sure if they are any b-only NICs
> under mac80211 so I didn't run to implement it.

at76_usb will be 11b only mac80211 driver whenever we manage to
complete the port.

-- 
Kalle Valo
