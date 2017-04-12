Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33276 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752412AbdDLO5r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 10:57:47 -0400
Received: by mail-io0-f176.google.com with SMTP id k87so28226210ioi.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 07:57:46 -0700 (PDT)
Subject: Re: [PATCH net-next v5 0/5] netlink extended ACK reporting
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20170412123408.22012-1-johannes@sipsolutions.net>
Cc: pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>, jiri@resnulli.us
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <24573d2e-abde-af5b-1b00-583dc687639e@cumulusnetworks.com> (sfid-20170412_165752_695787_005DA414)
Date: Wed, 12 Apr 2017 08:57:38 -0600
MIME-Version: 1.0
In-Reply-To: <20170412123408.22012-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/12/17 6:34 AM, Johannes Berg wrote:
> Changes since v4:
>  * use __NLMSGERR_ATTR_MAX instead of NUM_NLMSGERR_ATTRS
> 

Dave uses the cover letter with the change history in the merge commit
logs. Would be good to keep the design intent and history.
