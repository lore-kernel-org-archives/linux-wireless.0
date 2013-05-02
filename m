Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37460 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3EBUZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 16:25:08 -0400
Message-ID: <1367526288.11375.2.camel@jlt4.sipsolutions.net> (sfid-20130502_222515_334807_C9046FF0)
Subject: Re: mac80211:  3.9.0+:  Invalid WDS/flush state and non-connecting
 station.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 02 May 2013 22:24:48 +0200
In-Reply-To: <5182C38B.7060107@candelatech.com> (sfid-20130502_215043_578677_76592D19)
References: <5182C38B.7060107@candelatech.com>
	 (sfid-20130502_215043_578677_76592D19)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-02 at 12:50 -0700, Ben Greear wrote:
> Kernel is hacked 3.9.0+

Clearly :)

> I've been seeing this problem for a while (and posted about it previously).  The problem
> is that a station appears to associate fine, but never actually 'connects'.  This problem
> is not easy to reproduce...

It would be useful to know what you added ... the message you point to
(invalid wds/flush whatever) doesn't exist upstream.

johannes


