Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:43010 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbZI0ULu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 16:11:50 -0400
Subject: Re: [PATCH 1/2] net: introduce NETDEV_PRE_INIT notifier
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1254075999.6583.4.camel@johannes.local>
References: <1254075999.6583.4.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 13:11:34 -0700
Message-Id: <1254082294.2659.9.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> For various purposes including a wireless extensions
> bugfix, we need to hook into the netdev creation at
> a point before netdev_register_kobject(). It seems
> more generic, however, to have it even earlier. This
> will also ease doing the dev type assignment that
> Marcel was working on generically.

you are beating me to it. I can only second that this is a good idea for
the dev type assignment. Once Dave acks this I can sent a rebased patch
for the dev type stuff for WiFi.

Regards

Marcel


