Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:47611 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYLIRem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 12:34:42 -0500
Subject: Re: wireless drivers sparse warnings
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228823435.22164.216.camel@johannes.berg>
References: <1228823435.22164.216.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 12:34:40 -0500
Message-Id: <1228844080.4146.4.camel@dv> (sfid-20081209_183445_296068_0D3E849C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-12-09 at 12:50 +0100, Johannes Berg wrote:
> [minus uninteresting ones like "should be static"]

Please don't omit them next time.  Some functions may turn out to be
useless.

> drivers/net/wireless/orinoco/airport.c:282:2: warning: returning void-valued expression

I've just sent a fix for that.  Thanks!

-- 
Regards,
Pavel Roskin
