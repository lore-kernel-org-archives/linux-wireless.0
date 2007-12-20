Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3750 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbXLTDRU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 22:17:20 -0500
Subject: Re: [PATCH] iwlwifi: proper monitor support
From: Zhu Yi <yi.zhu@intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Sam Leffler <sam@errno.com>
In-Reply-To: <1ba2fa240712191608oa7f36e9ma05a04b4797d715a@mail.gmail.com>
References: <1198052938-25637-1-git-send-email-yi.zhu@intel.com>
	 <1ba2fa240712191604l1f5343c0s62e66aaf2077cce1@mail.gmail.com>
	 <1ba2fa240712191608oa7f36e9ma05a04b4797d715a@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 11:15:44 +0800
Message-Id: <1198120544.3065.30.camel@debian.sh.intel.com> (sfid-20071220_031726_571681_8EF8F29C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2007-12-20 at 02:08 +0200, Tomas Winkler wrote:
> I've made a mistake this is not logical but actual rate so it
> theoretically we can go up to 600Mbs so it will make it 120 < 256.

Um, should it be 1200 > 255?

> But aren't we interested in MSC rate a packet was sent?

NetBSD and wireshark support IEEE80211_RADIOTAP_XCHANNEL which does a
better job to extend the IEEE80211_RADIOTAP_CHANNEL functions including
per-channel power dbm, MCS rates, etc. Linux should catch up when we
have 11n fully supported.

Thanks,
-yi


