Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40622 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751855AbdF2H5q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 03:57:46 -0400
Message-ID: <1498723062.3141.0.camel@sipsolutions.net> (sfid-20170629_095750_185915_5F90CEE2)
Subject: Re: [PATCH] ieee80211: update public action codes
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <peter.oh@bowerswilkins.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 29 Jun 2017 09:57:42 +0200
In-Reply-To: <ccd3208a-8235-ffbc-79cd-422115f5f3ab@bowerswilkins.com>
References: <1498601249-8372-1-git-send-email-peter.oh@bowerswilkins.com>
         <d9aaa85b-49ac-494e-7979-afc42d309dc4@broadcom.com>
         <ccd3208a-8235-ffbc-79cd-422115f5f3ab@bowerswilkins.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-28 at 13:24 -0700, Peter Oh wrote:
> 
> On 06/28/2017 01:16 PM, Arend van Spriel wrote:
> > On 28-06-17 00:07, peter.oh@bowerswilkins.com wrote:
> > > From: Peter Oh <peter.oh@bowerswilkins.com>
> > > 
> > > Update Public Action field values as updated in IEEE Std 802.11-
> > > 2016,
> > > so that modules/drivers can refer it.
> > 
> > Hi Peter,
> > 
> > I am pretty sure there are a lot of other definitions in the 802.11
> > spec
> > that are not in a linux header file. So are you planning on
> > submitting
> > driver patches using the added definitions. Stuff is mostly added
> > as needed.

I think that's mostly laziness though :-) I'm perfectly happy to have
all these values in even if we don't use them now - they're not going
to change by not using.

> I have extra patches that uses the new values, but doubt if it's fit
> to be upstream.

I guess you can try :)

johannes
