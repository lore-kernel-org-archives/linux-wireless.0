Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:53943 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdJBVJV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 17:09:21 -0400
Received: by mail-wm0-f52.google.com with SMTP id q132so13078123wmd.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Oct 2017 14:09:20 -0700 (PDT)
Subject: Re: [PATCH] cfg80211/nl80211: add a port authorized event
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>, luca@coelho.fi
References: <20170929122149.29710-1-johannes@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0c8ca5c1-eabd-2cfa-ec5c-70dc0dfac61b@broadcom.com> (sfid-20171002_231133_753120_92D2E98A)
Date: Mon, 2 Oct 2017 23:09:18 +0200
MIME-Version: 1.0
In-Reply-To: <20170929122149.29710-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29-09-17 14:21, Johannes Berg wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> Add an event that indicates that a connection is authorized
> (i.e. the 4 way handshake was performed by the driver). This event
> should be sent by the driver after sending a connect/roamed event.

So is this event required for drivers supporting 4-way handshake 
offload. If so, the "should" above might need to be "shall" and I have 
some changes to do in brcmfmac ;-)

Regards,
Arend
