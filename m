Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab2KQIxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 03:53:37 -0500
Message-ID: <1353142451.9543.5.camel@jlt4.sipsolutions.net> (sfid-20121117_095341_598012_6439F8B3)
Subject: Re: [RFC 01/14] {nl,cfg,mac}80211: add beacon interval and DTIM
 period to mesh config
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org
Date: Sat, 17 Nov 2012 09:54:11 +0100
In-Reply-To: <1353134886-13256-2-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074838_606880_AF1877A1)
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353134886-13256-2-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 (sfid-20121117_074838_606880_AF1877A1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:47 -0800, Marco Porsch wrote:
> Moves the default mesh beacon interval and DTIM period to cfg80211 and
> makes it accessible to nl80211. This enables modifying both values at
> mesh runtime.

Which doesn't seem to be permitted "just like that", see 13.13.4.3.

johannes

