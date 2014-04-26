Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42450 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaDZBo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 21:44:58 -0400
Received: by mail-pa0-f43.google.com with SMTP id rd3so1922649pab.30
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 18:44:58 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/12] mac80211: remove unnecessary BUG_ON()
References: <cover.1398055853.git.gamerh2o@gmail.com>
	<fd686aea6dc877a9d6ecbfabba68b4e1e8b645d0.1398055854.git.gamerh2o@gmail.com>
	<1398439905.4152.16.camel@jlt4.sipsolutions.net>
Date: Sat, 26 Apr 2014 09:44:45 +0800
In-Reply-To: <1398439905.4152.16.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Fri, 25 Apr 2014 17:31:45 +0200")
Message-ID: <87oazovp82.fsf@gmail.com> (sfid-20140426_034501_986510_8F577BB2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-04-25 at 17:31:45 +0200, Johannes Berg wrote:
> On Mon, 2014-04-21 at 12:53 +0800, Zhao, Gang wrote:
>> The BUG_ON(!err) can't be triggered in the code path, so remove
>> it.
>
> Applied.
>
> Btw, it was a bit confusing that you sent your older patches in this
> patchset again, please avoid that or at least tell me you did that.

Sure. I thought previous sending failed due to network problem, but
it succeeded. Will check carefully.

> johannes
