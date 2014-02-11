Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49937 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaBKMA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 07:00:28 -0500
Message-ID: <1392120025.4128.4.camel@jlt4.sipsolutions.net> (sfid-20140211_130033_841299_59F6FE17)
Subject: Re: [PATCH] mac80211: fix IE buffer len
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Date: Tue, 11 Feb 2014 13:00:25 +0100
In-Reply-To: <1392119141-27279-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1392119141-27279-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-11 at 13:45 +0200, Emmanuel Grumbach wrote:
> From: David Spinadel <david.spinadel@intel.com>
> 
> Remove size of SSID IE from the IE buffer in scan and
> sched scan, since this IE isn't added to this buffer.

Applied

> Change-Id: Ic381cd50566529907c3a37f6aaa02d9132fd99da

with all that junk removed :)

johannes

