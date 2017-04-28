Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52424 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2993287AbdD1Mxp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 08:53:45 -0400
Message-ID: <1493384023.2431.17.camel@sipsolutions.net> (sfid-20170428_145618_779612_F3E4BE1B)
Subject: Re: [RFC] cfg80211: add control port state to struct
 cfg80211_connect_resp_params
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 28 Apr 2017 14:53:43 +0200
In-Reply-To: <49ec312c-6a2f-1bfe-820e-c14f1fa4baba@broadcom.com> (sfid-20170428_144642_384785_4A958630)
References: <1492808507-31224-1-git-send-email-arend.vanspriel@broadcom.com>
         <1493131210.2609.2.camel@sipsolutions.net>
         <b4dc7a6d-7865-1fb5-849a-0ead03a080c3@broadcom.com>
         <1493145418.2609.5.camel@sipsolutions.net>
         <af48efa4-3774-8d8b-ff45-760e558aa681@broadcom.com>
         <1493191249.2464.6.camel@sipsolutions.net>
         <c0b5817a-c4fa-8f7c-2632-cf22aa09d71b@broadcom.com>
         <1493380923.2431.13.camel@sipsolutions.net>
         <49ec312c-6a2f-1bfe-820e-c14f1fa4baba@broadcom.com>
         (sfid-20170428_144642_384785_4A958630)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-28 at 14:46 +0200, Arend Van Spriel wrote:

> I already have the 4-way-hs stuff rebased with modified ATTR_PMK
> description and additional length check in nl80211 for it. Jouni
> commented on that already in 4-way-hs patch.

Cool.

> > Do you want to pick that up? I probably can't do it soon - I'm
> > likely busy with other things the next week or two, then travel
> > again, ...
> 
> That is my plan.

Awesome, thanks!

johannes
