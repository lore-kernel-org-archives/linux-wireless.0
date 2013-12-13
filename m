Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:54233 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3LMRMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 12:12:48 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Luciano Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH v9 2/5] mac80211: align ieee80211_ibss_csa_beacon() with ieee80211_csa_beacon()
Date: Fri, 13 Dec 2013 18:12:41 +0100
Cc: linux-wireless@vger.kernel.org, yeohchunyeow@gmail.com,
	yeohchunyeow@cozybit.com
References: <1386935675-24548-1-git-send-email-luciano.coelho@intel.com> <1386935675-24548-3-git-send-email-luciano.coelho@intel.com>
In-Reply-To: <1386935675-24548-3-git-send-email-luciano.coelho@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201312131812.41312.sw@simonwunderlich.de> (sfid-20131213_181251_387053_489846B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The return value of ieee80211_ibss_csa_beacon is not aligned with the
> return value of ieee80211_csa_beacon().  For consistency and to be

You probably mean "ieee80211_assign_beacon()" here? There is no 
ieee80211_csa_beacon(), but AP uses ieee80211_assign_beacon(). Same goes for 
the commit message of patch 4. Content looks good.

Cheers,
    Simon
