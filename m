Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43620 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1950603AbdDZHUw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 03:20:52 -0400
Message-ID: <1493191249.2464.6.camel@sipsolutions.net> (sfid-20170426_092328_257339_64513BC6)
Subject: Re: [RFC] cfg80211: add control port state to struct
 cfg80211_connect_resp_params
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 26 Apr 2017 09:20:49 +0200
In-Reply-To: <af48efa4-3774-8d8b-ff45-760e558aa681@broadcom.com> (sfid-20170425_205607_063877_7FF3500F)
References: <1492808507-31224-1-git-send-email-arend.vanspriel@broadcom.com>
         <1493131210.2609.2.camel@sipsolutions.net>
         <b4dc7a6d-7865-1fb5-849a-0ead03a080c3@broadcom.com>
         <1493145418.2609.5.camel@sipsolutions.net>
         <af48efa4-3774-8d8b-ff45-760e558aa681@broadcom.com>
         (sfid-20170425_205607_063877_7FF3500F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-04-25 at 20:56 +0200, Arend Van Spriel wrote:
> 
> You might, but not about this ;-) The other approach I had in mind is
> to only pass the flag for drivers with 4-way-hs support. In that case
> wpa_supp also has to check that to determine whether the flag should
> be taken into account. Assuming the driver supporting 4-way-hs can
> provide the port state info. Otherwise, a new ext_feature flag would
> be needed.

I think it's reasonable to assume 4-way-HS offload drivers can support
it.

johannes
