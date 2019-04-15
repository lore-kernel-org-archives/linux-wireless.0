Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A31C10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 11:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED7EC2073F
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 11:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfDOLPp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 07:15:45 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:36750 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfDOLPp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 07:15:45 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hFzaR-0005uX-D6; Mon, 15 Apr 2019 13:15:43 +0200
Message-ID: <cf95c43bcfe1bd4d8fbc8aca8ecc65dac9eeae0c.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] wireless:  Support auth-at-ms timer in sta-info
From:   Johannes Berg <johannes@sipsolutions.net>
To:     greearb@candelatech.com, linux-wireless@vger.kernel.org
Date:   Mon, 15 Apr 2019 13:15:42 +0200
In-Reply-To: <20190412213710.17292-1-greearb@candelatech.com> (sfid-20190412_233719_267289_2072BA8E)
References: <20190412213710.17292-1-greearb@candelatech.com>
         (sfid-20190412_233719_267289_2072BA8E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-04-12 at 14:37 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Report time stamp of when sta became authenticated.

You didn't actually implement this ;-)

Did you mean associated?

> + * @auth_at_ms: time in ms of the last assoc -> auth transition.

There's commonly not really such a transition?

johannes

