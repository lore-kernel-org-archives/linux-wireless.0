Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4308 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXFKUYo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 16:24:44 -0400
Date: Mon, 11 Jun 2007 16:06:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	linux-wireless@vger.kernel.org, Joe Jezak <josejx@gentoo.org>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] softmac: use list_for_each_entry
Message-ID: <20070611200629.GH10397@tuxdriver.com>
References: <20070527142740.GB13105@APFDCB5C> <1180643064.18266.2.camel@johannes.berg> <46604279.3070908@lwfinger.net> <1180725169.11026.29.camel@johannes.berg> <20070611191854.GG10397@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070611191854.GG10397@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 11, 2007 at 03:18:54PM -0400, John W. Linville wrote:

> Plus, we may need to consider preserving the driver in its current
> form (aside from the softmac -> mac80211 port) for some time as a
> compatibility aid for those who already have working configurations
> with the "bcm43xx" driver.  Forcing a happy user to locate new firmware
> for no obvious benefit to them is not very nice (as I have learned
> so well w/ Fedora 7)...

As a re-read this, it seems subject to misinterpretation.  I mean
that once the existing bcm43xx driver (11g bits and all) is ported to
mac80211, we may want to keep the 11g bits even after the existing
bcm43xx-mac80211 (using v4 firmware) driver has been ported.
Worth considering...

John
-- 
John W. Linville
linville@tuxdriver.com
