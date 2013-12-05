Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab3LEQEb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 11:04:31 -0500
Message-ID: <1386259467.4182.13.camel@jlt4.sipsolutions.net> (sfid-20131205_170434_546674_3C2DECDE)
Subject: Re: [PATCH v8 4/5] mac80211: align ieee80211_mesh_csa_beacon() with
 ieee80211_csa_beacon()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com, yeohchunyeow@cozybit.com,
	andrei.otcheretianski@intel.com
Date: Thu, 05 Dec 2013 17:04:27 +0100
In-Reply-To: <1386257143-29840-5-git-send-email-luciano.coelho@intel.com> (sfid-20131205_162554_500402_7BA9FCA3)
References: <1386257143-29840-1-git-send-email-luciano.coelho@intel.com>
	 <1386257143-29840-5-git-send-email-luciano.coelho@intel.com>
	 (sfid-20131205_162554_500402_7BA9FCA3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 17:25 +0200, Luciano Coelho wrote:
> The return value of ieee80211_mesh_csa_beacon is not aligned with the
> return value of ieee80211_csa_beacon() and
> ieee80211_ibss_csa_beacon().  For consistency and to be able to use
> both functions with similar code, change ieee80211_mesh_csa_beacon()
> not to send the bss changed notification itself, but return what has
> changed so the caller can send the notification instead.

It seems to me that the caller should be updated?

johannes

