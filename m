Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52231 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab0KKPdv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 10:33:51 -0500
Message-ID: <4CDC0CBA.30201@ti.com>
Date: Thu, 11 Nov 2010 17:33:14 +0200
From: Gery Kahn <geryk@ti.com>
Reply-To: geryk@ti.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 06/15] mac80211: add support for HW periodic scan
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com> <1288612336-2830-7-git-send-email-luciano.coelho@nokia.com> <1288885537.3659.4.camel@jlt3.sipsolutions.net> <1288987177.25600.15.camel@powerslave> <03639d1a6cc12b36b036145a8c31da33@localhost>
In-Reply-To: <03639d1a6cc12b36b036145a8c31da33@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2010 09:55 PM, Johannes Berg wrote:
>
> On Fri, 05 Nov 2010 21:59:37 +0200, Luciano Coelho
> <luciano.coelho@nokia.com>  wrote:
>> I think the idea of using background is good.  Something like bg_scan or
>> something.  The original idea was to call it background scan, but since
>> wl1271 doesn't support this while connected, I thought calling it
>> periodic scan would be slightly clearer about that.  Background scan
>> sounds like you do it while connected (to me at least).
>
> Come to think of it though, we also call what we do when connected
> and trigger a scan manually a "background scan", so that's probably
> not a good name here.
>
> Not sure ... don't really have a good idea right now.
>
> johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
It may be sched_scan
