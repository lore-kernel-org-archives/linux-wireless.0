Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:43704 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdINTyn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 15:54:43 -0400
Received: by mail-io0-f172.google.com with SMTP id k101so3394671iod.0
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 12:54:43 -0700 (PDT)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1505378361.31630.2.camel@sipsolutions.net>
 <14eb89c4-680b-a1b9-c430-9f92a72bb86c@gmail.com>
 <1505414172.31630.13.camel@sipsolutions.net>
 <6f177c6d-ff79-bc9b-6ed6-e91a1ad96899@gmail.com>
 <1505416964.31630.17.camel@sipsolutions.net>
 <7210eb81-be88-8554-deb8-1926606ef64b@gmail.com>
 <1505418093.31630.21.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <94a01366-1af7-4728-59e4-847bfd8476e0@gmail.com> (sfid-20170914_215447_297497_FCC937FF)
Date: Thu, 14 Sep 2017 14:54:41 -0500
MIME-Version: 1.0
In-Reply-To: <1505418093.31630.21.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Well I guess any time that the carrier does in fact go down, you'd also
> reset oper state...
> 
> And now that I think about it, that does in fact happen in
> ieee80211_set_disassoc(), which we even go through for FT roaming.
> 
> Sounds like something we should fix?
> 

If you want roaming to keep oper state UP in all cases, then yes.  Does 
this work on full mac cards as well?

E.g. if I CMD_CONNECT to AP1, then pre-authenticate to AP2 and issue a 
CMD_CONNECT to AP2?

Regards,
-Denis
