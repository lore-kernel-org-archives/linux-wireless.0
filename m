Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:33360 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbeICQje (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 12:39:34 -0400
Message-ID: <1535977170.3437.62.camel@sipsolutions.net> (sfid-20180903_141945_174856_FDD54B6E)
Subject: Re: pull-request: mac80211 2018-09-03
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 03 Sep 2018 14:19:30 +0200
In-Reply-To: <20180903121546.27673-1-johannes@sipsolutions.net> (sfid-20180903_141604_430542_42638ACE)
References: <20180903121546.27673-1-johannes@sipsolutions.net>
         (sfid-20180903_141604_430542_42638ACE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-03 at 14:15 +0200, Johannes Berg wrote:
> Hi Dave,
> 
> This time around for mac80211 I have a larger than usual number of
> fixes, in part because Luca dumped our (Intel's) patches out after
> quite a while - we'll try to make sure this doesn't happen again.
> 
> Shortlog below, as usual, each fix is pretty self-contained but it
> adds up to quite a bit overall.
> 
> Please pull and let me know if there's any problem.

Oh, forgot: if/when you merge this, could you pull it into net-next at
some point? I have a patch that depends on this but isn't really net
material - it can wait though, so no hurry.

johannes
