Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab0HYHds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 03:33:48 -0400
Subject: Re: iwlagn fails to associate on 2.6.36-rc2
From: Johannes Berg <johannes@sipsolutions.net>
To: lance lassetter <lance@lass205.info>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1282690035.5180.16.camel@lass205.info>
References: <1282690035.5180.16.camel@lass205.info>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 09:35:24 +0200
Message-ID: <1282721724.3685.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-24 at 17:47 -0500, lance lassetter wrote:

> First is why this didn't happen with kernel 2.6.30?  Connection was
> automatically up upon thaw being complete.

I have no idea. 2.6.30 is very long ago.

> Second is how to restore wireless connectivity upon resume from
> hibernation without having to manually restart the network?

Run wpa_supplicant.

johannes

