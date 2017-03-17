Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:63620 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751390AbdCQPAP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 11:00:15 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT] brcmfmac: add support to move wiphy instance into network namespace
Date: Fri, 17 Mar 2017 09:05:35 -0400
Message-ID: <4209761.CsxqdDJGls@yow-masselst-lx1> (sfid-20170317_160050_022352_3B4842F2)
In-Reply-To: <1489755538.2544.11.camel@sipsolutions.net>
References: <1489528312-28304-1-git-send-email-arend.vanspriel@broadcom.com> <10023407.Rx0XN2k1RN@yow-masselst-lx1> <1489755538.2544.11.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, March 17, 2017 1:58:58 PM EDT Johannes Berg wrote:
> > > I guess this is intended behavior?
> > 
> > I had thought this was intended behavior as well but I see that a
> > patch is already prepped and tested to make this not happen. At any
> > rate it wasn't appearing to affect my usecase.
> 
> I can't actually see how it'd affect any usecase, since you really need
> to check inside the new netns what's going on etc. anyway, and you
> don't really want to pass such identifiers across the boundaries. But
> preserving it makes more sense, if only for debugging and making sure
> we won't run out of numbers :)

OK, I can see how preserving this makes sense for debugging. Understood and 
thanks for getting this namespace support in.

Mark

> 
> johannes
