Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41448 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3LPOKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 09:10:39 -0500
Message-ID: <1387203036.2057.5.camel@jlt4.sipsolutions.net> (sfid-20131216_151041_747205_88A6ED6D)
Subject: Re: [PATCH] mac80211: read station mgmt keys via get_key call
From: Johannes Berg <johannes@sipsolutions.net>
To: Max.Stepanov@intel.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 16 Dec 2013 15:10:36 +0100
In-Reply-To: <1386502289-10224-1-git-send-email-Max.Stepanov@intel.com> (sfid-20131208_123124_378716_A48E1780)
References: <1386502289-10224-1-git-send-email-Max.Stepanov@intel.com>
	 (sfid-20131208_123124_378716_A48E1780)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-12-08 at 13:31 +0200, Max.Stepanov@intel.com wrote:
> From: Max Stepanov <Max.Stepanov@intel.com>
> 
> Allow to read management keys stored in a station's gtk key
> array with a get_key function.

Applied.

johannes

