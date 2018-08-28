Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:50794 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbeH1MwO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 08:52:14 -0400
Message-ID: <1535446884.5895.16.camel@sipsolutions.net> (sfid-20180828_110145_516056_34270C6B)
Subject: Re: [PATCH 2/7] cfg80211: Add new NL command to configure peer
 specific rssi threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Aug 2018 11:01:24 +0200
In-Reply-To: <c8560bc51468cb1bd3f876aa6906afae@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
         <1528886747-26342-3-git-send-email-tamizhr@codeaurora.org>
         <1530264578.3481.34.camel@sipsolutions.net>
         <5d7f6ec9ffe0272b41102828f37706db@codeaurora.org>
         <1530877252.3197.5.camel@sipsolutions.net>
         <c8560bc51468cb1bd3f876aa6906afae@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-07-11 at 12:34 +0530, Tamizh chelvam wrote:

> I believe superset you meant will accept a signle threshold 
> configuration also from user ?

Yes.

> If so, we can remove the single threshold api implementation.

I think here we can remove the single threshold API - we have it in the
old only because some drivers still implement only a single threshold
(AFAICT), but for a new API I think we can reasonably require multiple
to be implemented.

johannes
