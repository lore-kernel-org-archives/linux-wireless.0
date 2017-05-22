Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49546 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752347AbdEVK2N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 06:28:13 -0400
Message-ID: <1495448886.2653.12.camel@sipsolutions.net> (sfid-20170522_122817_047777_810F8D03)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Date: Mon, 22 May 2017 12:28:06 +0200
In-Reply-To: <c3c14002-c9c5-490a-2e8f-826d601d0d84@broadcom.com> (sfid-20170522_121430_760021_DFAC4F08)
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
         <1495030794.2442.21.camel@sipsolutions.net>
         <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com>
         <1495099355.2553.1.camel@sipsolutions.net>
         <4e0672aa-51bc-115f-32b7-b1a8eb747e5b@broadcom.com>
         <1495104012.2553.3.camel@sipsolutions.net>
         <adcf52eb-cc8f-82de-3820-3f96a0d1f8d3@broadcom.com>
         <1495189263.3274.4.camel@sipsolutions.net>
         <c3c14002-c9c5-490a-2e8f-826d601d0d84@broadcom.com>
         (sfid-20170522_121430_760021_DFAC4F08)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-05-22 at 12:14 +0200, Arend van Spriel wrote:
> 
> There is a (small) chance of regression with older devices as stated 
> above and I would like to keep the fallback option for that. Also
> people  may like to have a choice. I am not so sure about whether
> NEW_KEY support is enough or a new ext_feature flag is needed. I am
> inclined to say the NEW_KEY support is sufficient.

Ok, your call.

Note that this (checking NEW_KEY) only works when you don't have any
split between AP/client cases. Not sure what's the case for you.

johannes
