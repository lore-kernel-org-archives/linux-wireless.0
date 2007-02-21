Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52891 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422725AbXBURp2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 12:45:28 -0500
Date: Wed, 21 Feb 2007 18:45:25 +0100
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [RFC PATCH] d80211: fix build break from netdev class_device ->  device changes
Message-ID: <20070221184525.4a40779b@griffin.suse.cz>
In-Reply-To: <20070221005811.GA3875@tuxdriver.com>
References: <20070221005811.GA3875@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 20 Feb 2007 19:58:11 -0500, John W. Linville wrote:
> In preparation for 2.6.21-rc1, I pulled Linus' latest tree into a
> branch of wireless-dev.  I hit a build problem with the sysfs stuff,
> due to the recent changes from class_device -> device for net_device.
> 
> Since I don't count sysfs as a strength, I thought it was worth
> posting this for some review before I actually pulled Linus' latest
> into wireless-dev and slapped this on top of it... :-)
> 
> Comments?

Looks correct. Don't know if it's complete, though - I tried to pull
from Linus but there are many conflicts caused by the ssb code, I'll
leave them to you :-)

Acked-by: Jiri Benc <jbenc@suse.cz>

I wonder if we can simplify it sometime in the future as we're getting
device_attribute in the callbacks now... Probably not. And it's not
worth the effort anyway.

-- 
Jiri Benc
SUSE Labs
