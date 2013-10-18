Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3JRPBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 11:01:34 -0400
Message-ID: <1382108488.14393.16.camel@jlt4.sipsolutions.net> (sfid-20131018_170148_436940_3A977B8F)
Subject: Re: pull-request: mac80211-next 2013-10-18
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 18 Oct 2013 17:01:28 +0200
In-Reply-To: <1382106708.14393.15.camel@jlt4.sipsolutions.net> (sfid-20131018_163205_790982_A7FB5088)
References: <1382106708.14393.15.camel@jlt4.sipsolutions.net>
	 (sfid-20131018_163205_790982_A7FB5088)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-18 at 16:31 +0200, Johannes Berg wrote:
> John,
> 
> Last one from me for today! :-)
> 
> In this round for mac80211-next I have:
>  * mesh channel switch support

Gah! evidently this is broken for !mesh.

johannes

