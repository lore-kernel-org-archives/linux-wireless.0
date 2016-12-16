Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58536 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755003AbcLPNJl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 08:09:41 -0500
Message-ID: <1481891767.27953.27.camel@sipsolutions.net> (sfid-20161216_140944_876661_F21B6A23)
Subject: Re: [RFC V3 04/11] nl80211: add driver api for gscan notifications
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 16 Dec 2016 13:36:07 +0100
In-Reply-To: <9715e731-efcc-0252-ed7b-5ca67e2c0b5b@broadcom.com> (sfid-20161216_131757_938930_7ED92539)
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
         <1481543997-24624-5-git-send-email-arend.vanspriel@broadcom.com>
         <1481646049.20412.43.camel@sipsolutions.net>
         <69ec7e9f-cd46-c46d-140c-0b30343cc0f7@broadcom.com>
         <1481882578.27953.20.camel@sipsolutions.net>
         <9715e731-efcc-0252-ed7b-5ca67e2c0b5b@broadcom.com>
         (sfid-20161216_131757_938930_7ED92539)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-12-16 at 13:17 +0100, Arend Van Spriel wrote:
> 
> > I have no problem introducing a common storage for this, if
> > necessary with some fields/nl attributes being optional, but I
> > suspect this is actually a necessary part of gscan, otherwise
> > you're not able to report all the necessary data?
> 
> If you just look at the gscan api in wifihal then yes. I was just
> wondering whether "all the necessary data" really comprises all these
> from a use-case perspective. As an example the api also has rtt
> fields, but both brcm and intel solutions do not report that.

Yeah, no idea. Sorry - my wording wasn't quite precise. By "this is
actually a necessary part of gscan" I meant the partial history
reporting itself, not any particular field thereof.

johannes
