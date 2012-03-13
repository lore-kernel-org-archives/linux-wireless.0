Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2CMNAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 09:00:21 -0400
Subject: Re: oops upon driver unload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4F5F4300.6090103@broadcom.com> (sfid-20120313_135234_397539_8DF6367C)
References: <4F5F4300.6090103@broadcom.com>
	 (sfid-20120313_135234_397539_8DF6367C)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Mar 2012 14:00:18 +0100
Message-ID: <1331643618.3329.2.camel@jlt3.sipsolutions.net> (sfid-20120313_140051_825379_9FCE25BE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-13 at 13:52 +0100, Arend van Spriel wrote:
> During testing I got an OOPS with the brcmsmac (see attachment). I 
> suspect mac80211 is using a driver callback after the module is removed 
> (could be wrong here). The connection with the AP is dropped, and after 
> 1 sec. the driver is unloaded using rmmod, which causes the driver to 
> unregister from mac80211.

What's the kernel version? I can't find your commit ("0e65d9a")

johannes

