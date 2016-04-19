Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49140 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbcDSJ55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 05:57:57 -0400
Message-ID: <1461059873.2766.18.camel@sipsolutions.net> (sfid-20160419_115800_721126_698A0898)
Subject: Re: [PATCHv3 4/5] mac80211: implement codel on fair queuing flows
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 19 Apr 2016 11:57:53 +0200
In-Reply-To: <CA+BoTQnrmf7RCGvwqO1tqu3MdDQtsEG7gq0F=gLMeud7W0d7Eg@mail.gmail.com> (sfid-20160419_113141_725026_0B4B8EA9)
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-5-git-send-email-michal.kazior@tieto.com>
	 <1460845772.2075.31.camel@sipsolutions.net>
	 <CA+BoTQkHAOhwFh5grveGCH5tfsxOT=BXAx2qgF1c=GcT7SrSQw@mail.gmail.com>
	 <CA+BoTQkQrUyihsk9MMMGY3XXGD+RqwziLwe+jKsKTG5q=StuAg@mail.gmail.com>
	 <1461056788.2766.13.camel@sipsolutions.net>
	 <CA+BoTQnrmf7RCGvwqO1tqu3MdDQtsEG7gq0F=gLMeud7W0d7Eg@mail.gmail.com>
	 (sfid-20160419_113141_725026_0B4B8EA9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-19 at 11:31 +0200, Michal Kazior wrote:

> > We should just get rid of all the rate stuff and convert everything
> > to use rate tables, but ... :)
> I'm guessing it's not trivial either and you risk breaking a lot of
> stuff? :)

It's not "tricky" in the same sense - but we'd have to convert drivers
to use a different data structure etc. Quite a bit of work.

johannes
