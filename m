Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:34657 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404AbXCZKOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 06:14:12 -0400
Message-ID: <46079CEC.5030207@warmcat.com>
Date: Mon, 26 Mar 2007 11:14:04 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>, Daniel Drake <dsd@gentoo.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kune@deine-taler.de
Subject: Re: [PATCH] zd1211rw-mac80211: Fix for monitor mode bug
References: <20070325231817.9C5887B409F@zog.reactivated.net>	 <20070326115412.2786c8f4@griffin.suse.cz> <1174903199.1536.4.camel@johannes.berg>
In-Reply-To: <1174903199.1536.4.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> bcm43xx doesn't tell you when the CRC failed, nor does it tell you when
> the PLCP CRC failed (if you want to see those frames). Hence, we'd have
> to recheck the CRC(s).

FWIW I can definitely use the broken frames despite the overhead and 
would welcome being able to get them via a config option.

-Andy
