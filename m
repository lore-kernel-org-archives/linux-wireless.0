Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57934 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760705AbXG0Rzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 13:55:50 -0400
Message-ID: <46AA31A4.3050205@lwfinger.net>
Date: Fri, 27 Jul 2007 12:55:48 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: pull request
References: <20070727192617.5ae82584@griffin.suse.cz>
In-Reply-To: <20070727192617.5ae82584@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> John,
> 
> please pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/jbenc/mac80211.git up-2.6
> to obtain patches below.
> 
> This is intended for wireless-2.6. Because of the number of patches and
> the fact they are not much tested, it's maybe a good idea not to push
> them upstream immediately - but that's up to you.

Now that a patch adding SSB to mainline is available, I will move bcm4301 into wireless-2.6 and do 
some testing of mac80211 that way.

Larry



