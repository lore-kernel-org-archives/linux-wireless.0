Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55177 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZFAOl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 10:41:26 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: alan-jenkins@tuffmail.co.uk,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243841263.5299.2.camel@johannes.local>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310651g41babab2hb05729b0699dd81f@mail.gmail.com>
	 <1243778069.5299.0.camel@johannes.local>
	 <1243796628.6570.37.camel@localhost.localdomain>
	 <1243841263.5299.2.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 16:41:03 +0200
Message-Id: <1243867263.3015.12.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > Maybe we should add an ioctl that disables rfkill-input if present.
> > 
> > I am against it. Can we just add a module parameter that allows us to
> > disable it. I am against cluttering a new interface with legacy stuff
> > since we are removing rfkill-input and replacing it by rfkilld anyway in
> > a near future (meaning when I am back from vacation).
> 
> Right. But you'll get a bunch of people get it mixed up. I think I would
> prefer adding the ioctl, but having it only when rfkill-input is
> compiled in, so userspace would always just get -ENOSYS if there's no
> rfkill-input present, which means the "cluttering" of the interface
> occurs only for as long as we have rfkill-input and at some point you
> would just remove that one line of code from rfkilld.

I can agree to your reasoning here. So that is fine with me.

Regards

Marcel


