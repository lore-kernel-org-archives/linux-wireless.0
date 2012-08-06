Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50201 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab2HFTGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:06:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SySd8-0004gJ-IU
	for linux-wireless@vger.kernel.org; Mon, 06 Aug 2012 21:06:18 +0200
Received: from 83.68.239.193 ([83.68.239.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 21:06:18 +0200
Received: from netuse by 83.68.239.193 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 21:06:18 +0200
To: linux-wireless@vger.kernel.org
From: Marco <netuse@lavabit.com>
Subject: Re: DHCP request timed out, iwlwifi
Date: Mon, 6 Aug 2012 21:06:07 +0200
Message-ID: <20120806210607.22c195f1@homerow> (sfid-20120806_210623_006330_2530D920)
References: <20120806161443.35c71558@homerow>
	<1344270901.11053.12.camel@dcbw.foobar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-06 Dan Williams <dcbw@redhat.com>
wrote:

> What kernel version?

3.2.0

> Is the network an 802.11n-enabled network?

Nope.

> If you have kernel version 3.2, try to disable 802.11n and see if
> that makes things happier.

Unfortunately not.

> Association happens correctly, but data frames do not work.

Sorry, I don't quite get it. What is the problem here (if you can
tell), a bug in the driver?

> Do something like the following:
> 
> rmmod iwlwifi
> modprobe iwlwifi 11n_disable=1
> (let it reconnect)

Same as before.

> Or, better yet, upgrade your kernel version to 3.4 or later, but
> that's probably not something that Canonical will do in the near
> future with 12.04.

If it helps, I can build and install my own kernel. What would you
suggest, any objections against 3.5.0 or should I go for a 3.4.0?

Thanks for your help.


Marco


