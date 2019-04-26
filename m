Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A818C4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 20:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5615820869
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 20:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfDZUOA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 16:14:00 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:41844 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfDZUOA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 16:14:00 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hK7EJ-00014X-2f; Fri, 26 Apr 2019 22:13:55 +0200
Message-ID: <01f1037952f77ae1aefc874ad02181fd5fa9c802.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211-next 2019-04-26
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Fri, 26 Apr 2019 22:13:53 +0200
In-Reply-To: <20190426.161122.317429832030080154.davem@davemloft.net>
References: <20190426111139.5831-1-johannes@sipsolutions.net>
         <20190426.161122.317429832030080154.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-04-26 at 16:11 -0400, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Fri, 26 Apr 2019 13:11:38 +0200
> 
> > And another set for -next, not that big this time.
> > See below for a summary of the highlights.
> > 
> > Please pull and let me know if there's any problem.
> 
> Pulled, thanks Johannes.
> 
> There was a minor confict in the TX code, two variables being added
> from different commits.

Oops, yeah, I knew about this but forgot to mention it, sorry about
that.

> Please double check my conflict resolution.

Looks fine, the order of the variables doesn't really matter and we do
need them both now :-)

johannes

