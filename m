Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1KOTMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 14:12:18 -0500
Subject: Re: [PATCH] minstrel_ht: Remove unused function parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Taht <dave.taht@gmail.com>
Cc: Patrick Kelle <patrick.kelle81@gmail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	nbd@openwrt.org
In-Reply-To: <CAA93jw7nWHnCnT48RJ00+Zxq9CFuCzhkeh=+7h+DqvYH2T7W1Q@mail.gmail.com> (sfid-20111115_201048_258376_C707079A)
References: <1321371888-26897-1-git-send-email-patrick.kelle81@gmail.com>
	 <CAA93jw7nWHnCnT48RJ00+Zxq9CFuCzhkeh=+7h+DqvYH2T7W1Q@mail.gmail.com>
	 (sfid-20111115_201048_258376_C707079A)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Nov 2011 20:12:14 +0100
Message-ID: <1321384334.3975.2.camel@jlt3.sipsolutions.net> (sfid-20111115_201221_806756_97543DE9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-15 at 20:10 +0100, Dave Taht wrote:
> It was kind of my hope that one day minstrel would export a useful API
> and statistics to other subsystems - like sysfs, tc or the upper parts of the
> network stack, and snmp.

I think that doesn't make a lot of sense -- it should be done at a more
abstract level.

johannes

