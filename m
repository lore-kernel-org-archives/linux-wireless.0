Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2548 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab0I2XTp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 19:19:45 -0400
Subject: Re: [PATCH 1/2] mac80211: Make no-probe-response kernel messages
 more useful.
From: Joe Perches <joe@perches.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=HC6bXdjkUgS9Evo5JgbAMiz3EAt_E7GJs9QZF@mail.gmail.com>
References: <1285783383-20822-1-git-send-email-greearb@candelatech.com>
	 <AANLkTi=HC6bXdjkUgS9Evo5JgbAMiz3EAt_E7GJs9QZF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 16:19:44 -0700
Message-ID: <1285802384.1866.215.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 09:03 +1000, Julian Calaby wrote:
> On Thu, Sep 30, 2010 at 04:03,  <greearb@candelatech.com> wrote:
> > From: Ben Greear <greearb@candelatech.com>
> > Add device name and flags to give better idea of what
> > exactly is happening.
> Is there a printk variant that does standardised formatting for the
> wireless device name?

wiphy_<level>, netdev_<level> and dev_<level> in
descending order of preference.


