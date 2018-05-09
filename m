Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53558 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965365AbeEIVa5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 17:30:57 -0400
Message-ID: <1525901454.6910.31.camel@sipsolutions.net> (sfid-20180509_233100_481932_B6ED5F0F)
Subject: Re: [wl-testing/master] build regression in brcmfmac
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 09 May 2018 23:30:54 +0200
In-Reply-To: <874ljgzfht.fsf@toke.dk>
References: <5AF36449.9050906@broadcom.com>
         <1525900945.6910.28.camel@sipsolutions.net> <874ljgzfht.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-09 at 23:27 +0200, Toke Høiland-Jørgensen wrote:

> That would be these:
> 
> https://patchwork.kernel.org/patch/10389333/
> https://patchwork.kernel.org/patch/10389331/
> https://patchwork.kernel.org/patch/10389335/
> 

D'oh, how did I miss that?!

Your fixes line is slightly wrong, it should be

Fixes: 12-digitid ("subject")

but I'm happy to fix that when I apply it.

johannes
