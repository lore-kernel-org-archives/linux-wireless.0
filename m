Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60764 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754802AbdA0MnU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 07:43:20 -0500
Message-ID: <1485520942.5851.9.camel@sipsolutions.net> (sfid-20170127_134618_548760_DBC13873)
Subject: Re: [PATCH 1/5] nl80211: fix validation of scheduled scan info for
 wowlan netdetect
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 27 Jan 2017 13:42:22 +0100
In-Reply-To: <abafc8a5-1138-7c4f-66a3-d606700440cb@broadcom.com> (sfid-20170127_133812_465827_35DBEB56)
References: <1485518971-28183-1-git-send-email-arend.vanspriel@broadcom.com>
         <1485518971-28183-2-git-send-email-arend.vanspriel@broadcom.com>
         <1485520288.5851.8.camel@sipsolutions.net>
         <abafc8a5-1138-7c4f-66a3-d606700440cb@broadcom.com>
         (sfid-20170127_133812_465827_35DBEB56)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-27 at 13:38 +0100, Arend Van Spriel wrote:
> 
> > IOW, I think Kalle can merge 2-5, and I can then pick up this one
> > when they hit net-next and I've synchronized, no?
> 
> Agree.

Alright. I see you submitted another version, I'll assign 2-5 to Kalle,
and keep 1 for myself, and not worry about the ordering since I'm the
one to have to remember to actually apply it later :)

johannes
