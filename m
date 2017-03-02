Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47534 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753587AbdCBIjm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 03:39:42 -0500
Message-ID: <1488443949.8390.5.camel@sipsolutions.net> (sfid-20170302_093945_427385_56010C46)
Subject: Re: [PATCH 099/306] mac80211-hwsim: notify user-space about channel
 change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 02 Mar 2017 09:39:09 +0100
In-Reply-To: <18699231-6ea2-5209-a384-d8f2c2adcdb9@candelatech.com>
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
         <1487918197.2540.1.camel@sipsolutions.net>
         <18699231-6ea2-5209-a384-d8f2c2adcdb9@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Looks like there are two conventions used (see
> HWSIM_CMD_TX_INFO_FRAME, and HWSIM_CMD_NEW_RADIO).  I guess you want
> it indented like the NEW_RADIO command?

Huh, sorry - yes, indented like NEW_RADIO please, I'll fix the others.

johannes
