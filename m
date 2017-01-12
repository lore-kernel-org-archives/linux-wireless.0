Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43382 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750780AbdALOcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 09:32:24 -0500
Message-ID: <1484231540.5391.6.camel@sipsolutions.net> (sfid-20170112_153227_561736_70E309B4)
Subject: Re: [PATCH 3/3] cfg80211: Specify the reason for connect timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Date: Thu, 12 Jan 2017 15:32:20 +0100
In-Reply-To: <20170112142926.GA19489@jouni.qca.qualcomm.com>
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
         <1483984388-30237-3-git-send-email-jouni@qca.qualcomm.com>
         <1484141491.29931.10.camel@sipsolutions.net>
         <20170112135843.GB17983@jouni.qca.qualcomm.com>
         <1484229979.5391.5.camel@sipsolutions.net>
         <20170112142926.GA19489@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> We don't.. This discussion here is about the C API where we cannot
> remove the argument from the call without adding yet another inline
> wrapper, but the actual function that generates the netlink message
> does not add the timeout reason attribute for success or explicit
> rejection cases.

Ah. But we can just say here then that it's ignored in those cases, and
not really worry about it?

johannes
