Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab0CUAhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 20:37:19 -0400
Subject: Re: Automated way of swipping in and out modules?
From: Johannes Berg <johannes@sipsolutions.net>
To: Rakesh Kumar <gopchandani@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <cdc21431003201535g40854df4ged9afd948660be19@mail.gmail.com>
References: <cdc21431003201534i5a10c871m1a76aba4f254345f@mail.gmail.com>
	 <cdc21431003201535g40854df4ged9afd948660be19@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 17:37:01 -0700
Message-ID: <1269131821.4611.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-03-20 at 17:35 -0500, Rakesh Kumar wrote:
> > Hello Folks,
> > So I have been hacking at cfg80211 and everytime I modify it, I have to rmmod all the dependent modules' tree on the top of it and then insert my newly modified module using insmod and then modprobe all the previously installed, dependent modules.
> > I was wondering if there is a faster way, which I am not aware of, to do this besides writing an script? If you have a working script, I would appreciate that too. :)

modprobe -r ?

johannes

