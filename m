Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54036 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbZAWTAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:00:47 -0500
Date: Fri, 23 Jan 2009 13:46:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2] mac80211: Fixed BSSID handling revisited
Message-ID: <20090123184643.GA30486@tuxdriver.com> (sfid-20090123_200051_333732_A2FED2AF)
References: <20090122023630.269690@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090122023630.269690@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 03:36:30AM +0100, Alina Friedrichsen wrote:
> This patch cleanup the fixed BSSID handling, that ieee80211_sta_set_bssid() works like ieee80211_sta_set_ssid(). So that the BSSID is only a second selection criterion besides the SSID. This allows us to create new IBSS networks with fixed BSSIDs, which was broken before.
> 
> In the second version of this patch the handling of the stupid merges to the same BSSID is moved out to get reworked into an other patch.
> 
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>

This is based on the patch I had to revert?  I'm going to drop this
one and wait for you to repost, just to avoid confusion.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
