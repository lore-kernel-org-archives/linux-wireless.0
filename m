Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57565 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbbEFMx2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 08:53:28 -0400
Message-ID: <1430916806.1954.3.camel@sipsolutions.net> (sfid-20150506_145332_108794_40BD974A)
Subject: Re: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the
 5.2 GHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 May 2015 14:53:26 +0200
In-Reply-To: <1428422722-655-1-git-send-email-ilan.peer@intel.com> (sfid-20150407_180542_808381_B43BAFDD)
References: <1428422722-655-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150407_180542_808381_B43BAFDD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, after all the discussion I've applied this.

When we decide how to advertise QAM-256 support on 2.4 GHz we can look
at adding it to hwsim as well.

johannes

