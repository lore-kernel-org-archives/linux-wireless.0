Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92371C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 12:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B1A92192B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 12:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbfBOMbs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 07:31:48 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:39932 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfBOMbr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 07:31:47 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1guced-0007DI-TJ; Fri, 15 Feb 2019 13:31:44 +0100
Message-ID: <f4c4649ac01a8a59afa1e71122b919d6b5a8aa7b.camel@sipsolutions.net>
Subject: Re: [PATCH AUTOSEL 3.18 15/16] cfg80211: extend range deviation for
 DMG
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Chaitanya Tata <chaitanya.tata@bluwirelesstechnology.com>,
        Chaitanya Tata <Chaitanya.Tata@bluwireless.co.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 15 Feb 2019 13:31:42 +0100
In-Reply-To: <20190215021546.179605-15-sashal@kernel.org> (sfid-20190215_031733_231971_3CB05612)
References: <20190215021546.179605-1-sashal@kernel.org>
         <20190215021546.179605-15-sashal@kernel.org>
         (sfid-20190215_031733_231971_3CB05612)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-02-14 at 21:15 -0500, Sasha Levin wrote:
> From: Chaitanya Tata <chaitanya.tata@bluwirelesstechnology.com>
> 
> [ Upstream commit 93183bdbe73bbdd03e9566c8dc37c9d06b0d0db6 ]
> 
> Recently, DMG frequency bands have been extended till 71GHz, so extend
> the range check till 20GHz (45-71GHZ), else some channels will be marked
> as disabled.

There's not really any danger in picking this up for old kernels, but
also practically no value since those kernels wouldn't have supoprt for
the higher ranges ("recently, ...") part :)

johannes

