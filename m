Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:48690 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbeCII7R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 03:59:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 09 Mar 2018 10:59:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: debugfs entries in cfg80211
In-Reply-To: <5A9D034D.9060203@broadcom.com>
 (sfid-20180305_094401_329661_B11F6C32)
References: <5A9D034D.9060203@broadcom.com>
 (sfid-20180305_094401_329661_B11F6C32)
Message-ID: <bea697dacbe725c636c5dfdd12d7ab2b@sipsolutions.net> (sfid-20180309_095932_780443_12B890AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Sorry for the late reply - just returning from Israel now (in fact I'm 
on the plane, but it has wifi).

> While reworking brcmfmac I stumbled on debugfs code in cfg80211, which
> creates the debugfs dir for the wiphy instance. It also creates a
> couple of entries, ie. rts and fragmentation threshold and retry
> limits. How useful are these as I suspect it is pretty old cruft and
> iw can obtain the information as well. Can it be removed.

No objection from me to removing them!

johannes
