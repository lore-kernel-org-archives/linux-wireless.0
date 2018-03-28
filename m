Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46332 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbeC1IDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 04:03:35 -0400
Message-ID: <1522224211.4222.0.camel@sipsolutions.net> (sfid-20180328_100341_236298_2D376DE6)
Subject: Re: [RFC 0/4] wireless: Per-sta NoAck and offload support
From: Johannes Berg <johannes@sipsolutions.net>
To: vthiagar@codeaurora.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Steve deRosier <derosier@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        steve.derosier@gmail.com
Date: Wed, 28 Mar 2018 10:03:31 +0200
In-Reply-To: <e4449f3b1dc37f3c91284f284211d1c9@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
         <CALLGbR+d8gCS0-_NV8i0K6ktL14OEiDjxVG4bvubmti7Yp5OoQ@mail.gmail.com>
         <94497d97976ff1934a08e70cc118bf56@codeaurora.org>
         <5ABB4636.2040900@broadcom.com>
         <e4449f3b1dc37f3c91284f284211d1c9@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-28 at 13:29 +0530, vthiagar@codeaurora.org wrote:
> On 2018-03-28 13:07, Arend van Spriel wrote:
> > On 3/28/2018 8:09 AM, vthiagar@codeaurora.org wrote:
> > > On 2018-03-27 22:18, Steve deRosier wrote:
> > > > Hi Vasanthakumar,
> > > > 
> > > > On Tue, Mar 27, 2018 at 1:42 AM, Vasanthakumar Thiagarajan
> > > > <vthiagar@codeaurora.org> wrote:
> > > > > Adds infrastructure for driver to offload NoAck functionality, 
> > > > > driver
> > > > > like ath10k could make use of it. Also extends the current ndev wide
> > > > 
> > > > I'm not really much of a fan of adding a feature without some use of
> > > > the feature. Perhaps if drivers "like" ath10k could use it, maybe you
> > > > should add a patch(s) to the series where one of those drivers
> > > > actually uses the feature.  An API without an example of use is also
> > > > harder to evaluate effectively.
> > > 
> > > I agree driver patch using the new NoAck infrastructure would help 
> > > with
> > > understanding, ill post it once it is ready. But not sure the driver 
> > > patch
> > > can be part of the same series.
> > 
> > The API patches would go in mac80211-next tree and indeed the driver
> > patch would go through wireless-drivers-next tree. However, an option
> > would be to add the driver patch(es) as RFC in the series so Johannes
> > can ignore it and we still have an example to look at.

FWIW, you can just include it as a regular [PATCH] - Kalle and I have a
way of dealing with that - he just assigns it over to me initially, and
I assign back once the prerequisites have landed.

johannes
