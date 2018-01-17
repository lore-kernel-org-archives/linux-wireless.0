Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36178 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbeAQIoH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 03:44:07 -0500
Message-ID: <1516178638.410.53.camel@sipsolutions.net> (sfid-20180117_094411_128260_F1A58B6D)
Subject: Re: [PATCH v2 05/10] rtlwifi: enable mac80211 fast-tx support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>, pkshih@realtek.com
Cc: Larry.Finger@lwfinger.net, yhchuang@realtek.com,
        linux-wireless@vger.kernel.org
Date: Wed, 17 Jan 2018 09:43:58 +0100
In-Reply-To: <5A5F0B32.4090006@broadcom.com> (sfid-20180117_093710_496835_7E7FC2B9)
References: <20180111070932.9929-1-pkshih@realtek.com>
         <20180111070932.9929-6-pkshih@realtek.com>
         <871sip24fc.fsf@purkki.adurom.net> <5A5E5C99.5020607@broadcom.com>
         <1516141444.410.52.camel@sipsolutions.net> <5A5F0B32.4090006@broadcom.com>
         (sfid-20180117_093710_496835_7E7FC2B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-17 at 09:37 +0100, Arend van Spriel wrote:
> 
> I am getting old. In my recollection the fragmentation threshold would 
> be set to maximum MPDU size, which I believed to be 2346. Not sure if 
> that still is true today. To be sure taken a look in the 2016 spec:
> 
> """
> dot11FragmentationThreshold OBJECT-TYPE
> SYNTAX Unsigned32 (256..65535)

I think the larger sizes are for 60 GHz.

> Anyway, the fact remains that we should leave it up to the user to 
> control the value.

Indeed.

johannes
