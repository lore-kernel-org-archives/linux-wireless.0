Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60448 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934241AbdA0Lwg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 06:52:36 -0500
Message-ID: <1485516428.5851.6.camel@sipsolutions.net> (sfid-20170127_125245_395723_F4AB82F1)
Subject: Re: [PATCH] nl80211: fix validation of scheduled scan info for
 wowlan netdetect
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 27 Jan 2017 12:27:08 +0100
In-Reply-To: <a36abf1d-5d4b-4c37-e325-a69166663a04@broadcom.com> (sfid-20170127_122523_881598_29BEDE90)
References: <1484820088-24448-1-git-send-email-arend.vanspriel@broadcom.com>
         <1484827206.2774.12.camel@coelho.fi>
         <bde55d09-6f3e-1f90-4aef-0e1169c11cf6@broadcom.com>
         <1485248251.7244.3.camel@sipsolutions.net>
         <13d1e654-6928-39e7-4751-fb90d3da7a54@broadcom.com>
         <a36abf1d-5d4b-4c37-e325-a69166663a04@broadcom.com>
         (sfid-20170127_122523_881598_29BEDE90)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I actually have two dependent brcmfmac patches. Do you expect
> conflict if Kalle takes all?

Not really, if that's somehow easier we can do that.

johannes
