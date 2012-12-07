Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:57701 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887Ab2LGJ3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 04:29:41 -0500
Message-ID: <50C1B702.1030601@posedge.com> (sfid-20121207_102957_140293_B6C63647)
Date: Fri, 07 Dec 2012 14:59:38 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix the multiple warnings for budding chipsets
 without ampdu_action defined
References: <201212070645.qB76jSjN013395@chaitanya-desktop>  <50C1917E.2010407@posedge.com> <1354868041.9552.7.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354868041.9552.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great to hear that johannes.
Finally after exhausting all options used the sendmail and it worked :-)

On Friday 07 December 2012 01:44 PM, Johannes Berg wrote:
> On Fri, 2012-12-07 at 12:19 +0530, Chaitanya wrote:
>> Warn once should suffice.
>>
>> Eg: our driver doesn't support the ampdu_action yet, so
>> seeing a lot of warnings, hence the check for any
> Yay, this worked. Applied with a changed commit log.
>
> johannes
>

