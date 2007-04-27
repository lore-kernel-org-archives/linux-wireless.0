Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47445 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757180AbXD0ULb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 16:11:31 -0400
Date: Fri, 27 Apr 2007 22:11:53 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Wireless rates with mac80211
Message-ID: <20070427221153.7ecc04de@griffin.suse.cz>
In-Reply-To: <462F9617.8010207@lwfinger.net>
References: <462F9617.8010207@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 25 Apr 2007 12:55:35 -0500, Larry Finger wrote:
> In mac80211, the SIOC{S,G}IWRATE commands are not implemented. Is there another way to find out what 
> transmission rate is being used?

If you have debugfs compiled in, you can look into
<debugfs_mount_point>/ieee80211/phy0/stations/*/rc_simple_tx_avg_rate_[ns]um.
But that's just average.

 Jiri

-- 
Jiri Benc
SUSE Labs
