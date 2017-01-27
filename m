Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34306 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932544AbdA0L34 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 06:29:56 -0500
Received: by mail-pf0-f182.google.com with SMTP id e4so72717049pfg.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2017 03:29:55 -0800 (PST)
Subject: Re: [PATCH] nl80211: fix validation of scheduled scan info for wowlan
 netdetect
To: Johannes Berg <johannes@sipsolutions.net>,
        Luca Coelho <luca@coelho.fi>
References: <1484820088-24448-1-git-send-email-arend.vanspriel@broadcom.com>
 <1484827206.2774.12.camel@coelho.fi>
 <bde55d09-6f3e-1f90-4aef-0e1169c11cf6@broadcom.com>
 <1485248251.7244.3.camel@sipsolutions.net>
 <13d1e654-6928-39e7-4751-fb90d3da7a54@broadcom.com>
 <a36abf1d-5d4b-4c37-e325-a69166663a04@broadcom.com>
 <1485516428.5851.6.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <be17fb77-9d9b-0889-f73c-735119730ffc@broadcom.com> (sfid-20170127_123005_368679_A9F63E17)
Date: Fri, 27 Jan 2017 12:29:51 +0100
MIME-Version: 1.0
In-Reply-To: <1485516428.5851.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-1-2017 12:27, Johannes Berg wrote:
> 
>> I actually have two dependent brcmfmac patches. Do you expect
>> conflict if Kalle takes all?
> 
> Not really, if that's somehow easier we can do that.

Will do. I checked the other drivers. All those supporting wowl
netdetect did provide max_nd_matchsets except for brcmfmac.


Regards,
Arend
