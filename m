Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:34418 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbXIXM7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 08:59:49 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IZnWl-0007Ud-Ui
	for linux-wireless@vger.kernel.org; Mon, 24 Sep 2007 08:59:08 -0400
Subject: Re: API to regulatory control (1)
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1190456574.18521.220.camel@johannes.berg>
References: <1190456574.18521.220.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 08:59:35 -0400
Message-Id: <1190638775.21374.5.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-09-22 at 12:22 +0200, Johannes Berg wrote:

> struct ieee80211_channel {
> 	/* first part set by driver */
> 	u16 freq;		/* in MHz */
> 	int hardware_value;	/* arbitrary */

Please consider using "long" for hardware_value.  Drivers should be able
to use this value as a pointer to some driver-specific structure.

-- 
Regards,
Pavel Roskin

