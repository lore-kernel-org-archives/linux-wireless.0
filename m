Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2DFPLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 11:11:33 -0400
Message-ID: <1333725089.5577.0.camel@jlt3.sipsolutions.net> (sfid-20120406_171152_864558_C15746F9)
Subject: Re: carl9170: not able to add P2P_GO - add_interface fail with
 -EBUSY
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 06 Apr 2012 17:11:29 +0200
In-Reply-To: <201204061322.26832.chunkeey@googlemail.com> (sfid-20120406_132302_219753_F45C99D1)
References: <CAFED-jno-531+5TPOjDJ598jAO1zMmFpe6UJOsRt4SfbCU9zDQ@mail.gmail.com>
	 <201204061322.26832.chunkeey@googlemail.com>
	 (sfid-20120406_132302_219753_F45C99D1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-04-06 at 13:22 +0200, Christian Lamparter wrote:

> > Is that chipset limitation we could add only new STA interface when
> > main_vif is also STA?
> <http://wireless.kernel.org/en/users/Drivers/carl9170#Multiple_Interfaces>
> no, it's not. But you'll have to go through several hoops to extend
> the driver to switch the "main" interface while the device is up and
> running.

So the driver has a concept of the order in which interfaces are added?
That's something I never considered when writing the interface type
combinations support.

johannes

