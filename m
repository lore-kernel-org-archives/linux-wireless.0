Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:39164 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752801AbeCXVXG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 17:23:06 -0400
Subject: Re: [PATCH 1/3] ieee80211: Replace bit shifts with the BIT() macro
 for WLAN_CAPABILITY_*.
To: Quytelda Kahja <quytelda@tamalin.org>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180324041027.6498-1-quytelda@tamalin.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e31eb13b-598b-e7c7-607b-c98664818563@lwfinger.net> (sfid-20180324_222324_502645_AA9620DF)
Date: Sat, 24 Mar 2018 16:23:02 -0500
MIME-Version: 1.0
In-Reply-To: <20180324041027.6498-1-quytelda@tamalin.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/23/2018 11:10 PM, Quytelda Kahja wrote:
> It is neater and more consistent with the rest of the document to use the
> BIT() macro from 'linux/bitops.h' to define the WLAN_CAPABILITY_*
> bitmasks.  In the case of WLAN_CAPABILITY_DMG_TYPE_{IBSS, PBSS, AP},
> bitshifting integers by 0 does nothing, so there is no reason to do it in
> the code; replace these values with plain integers.
> 
> Signed-off-by: Quytelda Kahja <quytelda@tamalin.org>

In the commit message for all of these, what is the "document" to which you refer?

I'm not quite sure why you split these changes into 3 parts, but I guess that is OK.

Larry
