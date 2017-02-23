Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33464 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751049AbdBWKzf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 05:55:35 -0500
Message-ID: <1487846241.18380.2.camel@sipsolutions.net> (sfid-20170223_115539_028158_125C34C6)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Jithu Jance <jithu.jance@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        Jouni Malinen <j@w1.fi>
Date: Thu, 23 Feb 2017 11:37:21 +0100
In-Reply-To: <9b6de09f-d872-fd67-971a-6da369fefe1a@broadcom.com> (sfid-20170223_113633_280663_6FA7C88C)
References: <20170221100957.30965-1-johannes@sipsolutions.net>
         <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com>
         <1487673603.2215.3.camel@sipsolutions.net>
         <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com>
         <1487680651.2215.5.camel@sipsolutions.net>
         <3fa1e3ac-5722-c46d-acc1-62407f4eef07@broadcom.com>
         <CA+gyVQ11yZjkJXjiVoMVijs=_K8itZMQrces9XQha_bT4=H-DA@mail.gmail.com>
         <9b6de09f-d872-fd67-971a-6da369fefe1a@broadcom.com>
         (sfid-20170223_113633_280663_6FA7C88C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> So the code in wpa_supplicant_event_assoc() is either lying or the
> assoc event should come after driver has completed successfully. To
> me it seems worth it to have NL80211_CMD_EAP_COMPLETED event carrying
> the result or indeed give the CONNECTED event later in the driver.

Sorry - need to look at this in more detail later.

But yes, we do give CONNECTED event later in the driver right now.

johannes
