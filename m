Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52348 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751753AbdFMJGB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 05:06:01 -0400
Message-ID: <1497344759.6068.6.camel@sipsolutions.net> (sfid-20170613_110621_591878_53E24EEA)
Subject: Re: [PATCH V3 0/9] nl80211: add support for PTK/GTK handshake
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Jun 2017 11:05:59 +0200
In-Reply-To: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-09 at 13:08 +0100, Arend van Spriel wrote:
> 
> Arend van Spriel (6):
>   nl80211: add authorized flag to CONNECT event

I skipped this.

>   nl80211: remove desciption about request from NL80211_CMD_ROAM

applied

>   brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK
>   brcmfmac: support 4-way handshake offloading for 802.1X
>   brcmfmac: switch to using cfg80211_connect_done()
>   brcmfmac: provide port authorized state in CONNECT event

For Kalle later.

> Avraham Stern (2):
>   cfg80211: support 4-way handshake offloading for 802.1X
>   nl80211: add authorized flag to ROAM event
> 
> Eliad Peller (1):
>   cfg80211: support 4-way handshake offloading for WPA/WPA2-PSK

Applied.

Thanks a lot Arend for taking care of all this!

johannes
