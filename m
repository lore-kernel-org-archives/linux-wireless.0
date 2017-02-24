Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42398 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750973AbdBXGhr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 01:37:47 -0500
Message-ID: <1487918215.2540.2.camel@sipsolutions.net> (sfid-20170224_073811_351771_48258249)
Subject: Re: [PATCH 100/306] mac80211-hwsim: remove dmesg spam about
 get-survey.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Fri, 24 Feb 2017 07:36:55 +0100
In-Reply-To: <1487896109-23851-2-git-send-email-greearb@candelatech.com> (sfid-20170224_012922_949353_E2FF91A1)
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
         <1487896109-23851-2-git-send-email-greearb@candelatech.com>
         (sfid-20170224_012922_949353_E2FF91A1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-02-23 at 16:28 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This message just fills up dmesg and/or kernel logs and does
> not provide any useful information.

Fine, but don't just comment it out.

johannes
