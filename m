Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab1KDOPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 10:15:05 -0400
Subject: Re: Open80211s on Android -- iw EOPNOTSUPP error when trying to
 join mesh network?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kiran Karra <kiran.karra@gmail.com>
Cc: linux wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CAAaUcVxoeOVqXBfSH0WivmOg32yoXMOZTkStg1HxECkAJsv6+Q@mail.gmail.com> (sfid-20111104_150619_435082_482D0478)
References: <CAAaUcVxoeOVqXBfSH0WivmOg32yoXMOZTkStg1HxECkAJsv6+Q@mail.gmail.com>
	 (sfid-20111104_150619_435082_482D0478)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 15:14:59 +0100
Message-ID: <1320416099.3969.83.camel@jlt3.sipsolutions.net> (sfid-20111104_151510_001132_0D515517)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 10:06 -0400, Kiran Karra wrote:

> # cd /system/lib/modules
> # insmod p54usb.ko
> The wireless driver loads fine.  Next, if I type in:
> # iw phy0 info
> I get a lot of information about my wifi dongle's capabilities.  In
> the "Supported interface modes" section, I see that "mesh point" is
> supported.
> 
> After this, I do the command:
> # iw phy0 init

Since this doesn't exist upstream, all bets are off from this point on
and you're on your own.

johannes

