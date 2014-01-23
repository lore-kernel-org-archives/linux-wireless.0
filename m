Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbaAWIUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 03:20:46 -0500
Message-ID: <1390465244.4142.3.camel@jlt4.sipsolutions.net> (sfid-20140123_092050_125358_D08C1954)
Subject: Re: [PATCH 1/2] mac80211:  Extra debug info for station cleanup
 case.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 09:20:44 +0100
In-Reply-To: <52E05B2E.7030200@candelatech.com>
References: <1390431296-20568-1-git-send-email-greearb@candelatech.com>
	  (sfid-20140122_235532_670534_4FD6E588) <1390432284.20070.1.camel@jlt4.sipsolutions.net>
	 <52E05B2E.7030200@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 15:58 -0800, Ben Greear wrote:

> > You should put the string into the warning
> > 
> > WARN_ONCE(ret, "sta-info-destroy: ...", ...)
> 
> I wanted it to kernel splat once and print out a message, and after that, only print
> messages.
> 
> I think your suggestion will only splat _and_ print once?

Hm, that's true, but it shouldn't be happening anyway? So why would you
care about subsequent instances - even the first is a bug?

johannes

