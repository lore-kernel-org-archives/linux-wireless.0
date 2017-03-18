Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46444 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbdCRUIj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Mar 2017 16:08:39 -0400
Message-ID: <1489866302.13995.3.camel@sipsolutions.net> (sfid-20170318_211217_252907_3CB6736C)
Subject: Re: [BUG] with a 4.10.x kernel it's impossible to apply country
 regulatory rules
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Sat, 18 Mar 2017 20:45:02 +0100
In-Reply-To: <8c844f92-6148-2ad7-068c-a919891c7a90@lwfinger.net> (sfid-20170318_184148_834282_FCD36BD9)
References: <09a819fc-c936-6838-654b-e349c58a09ec@gmail.com>
         <8c844f92-6148-2ad7-068c-a919891c7a90@lwfinger.net>
         (sfid-20170318_184148_834282_FCD36BD9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-03-18 at 12:41 -0500, Larry Finger wrote:
> 
> I have duplicated your bug and I have bisected it to
> 
> commit 2ae0f17df1cd52aafd1ab0415ea1f1dd56dc0e2a
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Mon Oct 24 14:40:04 2016 +0200
> 
>      genetlink: use idr to track families
> 
> This patch is quite extensive and I have no idea which part is
> failing, thus all I can do is report this confirmation.

I don't think that makes any sense - have you verified that reverting
that makes it go away?

johannes
