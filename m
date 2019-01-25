Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58951C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 268DB218D9
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfAYMQv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:16:51 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56354 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfAYMQv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 07:16:51 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gn0Ph-0008Ge-PL; Fri, 25 Jan 2019 13:16:49 +0100
Message-ID: <f7bd37892d5b466312613d613866ca5dd27019e8.camel@sipsolutions.net>
Subject: Re: [PATCH 01/12] mac80211: pass bssids to elements parsing function
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Date:   Fri, 25 Jan 2019 13:16:48 +0100
In-Reply-To: <20190125114825.5872-1-johannes@sipsolutions.net> (sfid-20190125_124841_946714_25BD29CA)
References: <20190125114825.5872-1-johannes@sipsolutions.net>
         (sfid-20190125_124841_946714_25BD29CA)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-01-25 at 12:48 +0100, Johannes Berg wrote:
> From: Sara Sharon <sara.sharon@intel.com>

This is Peng's patch, I'll fix that.

Also though, with all these patches the hwsim tests now crash the
kernel, so we'll have more work to do on these ...

johannes

