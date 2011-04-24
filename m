Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab1DXSia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 14:38:30 -0400
Subject: Re: [PATCH 1/1 RFC] mac80211: add ratio to led blinking trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1303665300-1775-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110424_191812_851726_8A7D5FAA)
References: <1303665300-1775-1-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110424_191812_851726_8A7D5FAA)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 20:38:26 +0200
Message-ID: <1303670306.3603.5.camel@jlt3.sipsolutions.net> (sfid-20110424_203843_826122_30CBA42E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-24 at 10:15 -0700, Wey-Yi Guy wrote:
> The current led blink trigger implementaion assume on/off time are equal,
> it works but not have any flexbile for different blink pattern.
> 
> Add "ratio" parameter in the trigger table and give driver more control
> on how the on/off blink time behavior should be.

I considered this when writing the original code, but then decided that
nobody needed to have unequal on/off times. Why would we need it now?
(FWIW, blink = 0 is always on already, no?)

johannes

