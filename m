Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53772 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732441AbeITTYk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 15:24:40 -0400
Date: Thu, 20 Sep 2018 16:40:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: kbuild@01.org, kbuild-all@01.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, Eliad Peller <eliad@wizery.com>,
        mathias.kretschmer@fit.fraunhofer.de
Subject: Re: [PATCH] mac80211: allow scans on radar channels, unless there is
 CAC or CSA
Message-ID: <20180920134043.jiivbvnmjnobzztr@mwanda> (sfid-20180920_154110_565962_75163622)
References: <20180920092014.ajgykw7o7p73grfj@mwanda>
 <1800056.zUtZK9dVLA@prime>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1800056.zUtZK9dVLA@prime>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 20, 2018 at 03:30:05PM +0200, Simon Wunderlich wrote:
> Hi Dan,
> 
> whoops, right ... thank you!
> 
> Will do in a v2, at least if this patch is wanted. :)
> 

These are automated emails, I just look at them and forward them.  I
don't actually "love your patch" because I haven't even looked at it.
The bot adds that text to sound more friendly...

Presumably the patch is wanted, but I don't know.  Anyway, yes, please
do send a v2.

regards,
dan carpenter
