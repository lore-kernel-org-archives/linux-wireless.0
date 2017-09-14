Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51830 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751718AbdINTjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 15:39:12 -0400
Message-ID: <1505417948.31630.19.camel@sipsolutions.net> (sfid-20170914_213922_639923_36051E12)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 14 Sep 2017 21:39:08 +0200
In-Reply-To: <9219316a-5556-6acf-30de-e9aa65a05706@gmail.com> (sfid-20170914_213406_895369_2C934E54)
References: <1505378361.31630.2.camel@sipsolutions.net>
         <e4a3ab99-f49a-0849-56d7-71ce19b1f323@broadcom.com>
         <1505389462.31630.6.camel@sipsolutions.net>
         <e418234f-00a0-dd44-7352-d279f49f83e5@gmail.com>
         <1505416658.31630.15.camel@sipsolutions.net>
         <9219316a-5556-6acf-30de-e9aa65a05706@gmail.com>
         (sfid-20170914_213406_895369_2C934E54)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-14 at 14:34 -0500, Denis Kenzior wrote:

> > I think you pretty much have to assume that, otherwise there's no
> > point
> > in roaming at all - you want your connections to stay, possibly
> > voice
> > calls to continue, etc.
> 
> I'm all for using this assumption.  I just wonder if real world 
> disagrees? :)

I think you can probably find networks where this doesn't work, but I
don't think we should cater for that. And corporate networks done with
Cisco, Aruba or similar should have it work correctly, and in fact I'd
assume that it's pretty much only broken if you take two consumer APs
and configure them to the same SSID or something ...

johannes
