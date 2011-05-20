Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935041Ab1ETS4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 14:56:30 -0400
Subject: Re: netlink reverts
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1305917869.4640.15.camel@jlt3.sipsolutions.net> (sfid-20110520_205514_667520_F3430A59)
References: <1305917869.4640.15.camel@jlt3.sipsolutions.net>
	 (sfid-20110520_205514_667520_F3430A59)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 11:59:09 -0700
Message-ID: <1305917949.4640.16.camel@jlt3.sipsolutions.net> (sfid-20110520_205633_189418_B282BD9A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-20 at 11:57 -0700, Johannes Berg wrote:
> John,
> 
> Please revert
> 9c3990aaec0ad9f686ef6480f6861f2df89b2a7a
> ASAP; you'll have to revert
> 8958da779b92da60e90d9761549b88677a6a3eef
> first. (alternatively, if you're feeling less pissed off than I am you
> can fix it I guess)
> 
> Javier fucked up the netlink attribute types again by inserting
> something in the middle, and I'm really mad about it too.

Hmm, maybe I shot first and then asked questions ;-) Looking at it again
it _might_ have been introduced by merge issues?

In any case there's a patch inserting an attribute in the middle. GRRRR.

johannes

