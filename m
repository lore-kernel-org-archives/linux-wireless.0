Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58090 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbcHLGAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 02:00:05 -0400
Message-ID: <1470981569.26902.5.camel@sipsolutions.net> (sfid-20160812_080013_444464_9FDA95C8)
Subject: Re: [PATCH 1/4] cfg80211: rdev-ops: remove callback check from
 rdev_set_coalesce()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 12 Aug 2016 07:59:29 +0200
In-Reply-To: <ee2929c1-1f1b-ca1e-07d2-a3f43f8b73a8@broadcom.com> (sfid-20160811_210047_474331_799A5709)
References: <1470825209-10054-1-git-send-email-arend.vanspriel@broadcom.com>
	 <1470919713.12075.8.camel@sipsolutions.net>
	 <ee2929c1-1f1b-ca1e-07d2-a3f43f8b73a8@broadcom.com>
	 (sfid-20160811_210047_474331_799A5709)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I was in doubt to raise the question first about getting this stuff
> consistent, ie. keep rdev-ops as flat as possible, but decided just
> to put it out there in patch format. My bad :-)

:-)

> If you want the rdev-ops to be safe against (future) callers not
> checking the callback, it seems you should add a check in all rdev-
> ops where the callback is optional.

Yeah, perhaps. I don't really mind hugely either way, but I think
removing them now would mostly be unwarranted churn.

johannes
