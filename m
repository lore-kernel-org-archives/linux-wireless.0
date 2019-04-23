Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D500DC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 10:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABB4C2077C
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 10:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfDWKRF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 06:17:05 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59194 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfDWKRE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 06:17:04 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hIsU3-0004wj-7z; Tue, 23 Apr 2019 12:17:03 +0200
Message-ID: <7470cbfc4c75e6c1679db152d0ac310a51e86a35.camel@sipsolutions.net>
Subject: Re: mac80211_hwsim: EXT_FEATURE_CAN_REPLACE_PTK0 ?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <james.prestwood@linux.intel.com>,
        linux-wireless@vger.kernel.org
Date:   Tue, 23 Apr 2019 12:17:02 +0200
In-Reply-To: <8b0806411029f7d839691f28de49e52c27404895.camel@sipsolutions.net> (sfid-20190423_121627_037424_58B626A9)
References: <9e8cac221ec049f2359d5fc35de6145a45fbeaaa.camel@linux.intel.com>
         (sfid-20190422_180755_414723_A6B1470E) <8b0806411029f7d839691f28de49e52c27404895.camel@sipsolutions.net>
         (sfid-20190423_121627_037424_58B626A9)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-04-23 at 12:16 +0200, Johannes Berg wrote:
> On Mon, 2019-04-22 at 09:07 -0700, James Prestwood wrote:
> > Hi,
> > 
> > I know for actual hardware drivers this feature requires more than just
> > the flip of a switch, but is there any technical reason why this is not
> > turned on in mac80211_hwsim? I know it was added relatively recently,
> > so maybe mac80211_hwsim just hasn't turned it on yet? If there are no
> > objections to enabling it, I can send a patch.
> 
> In case you didn't see, Alexander just sent a patch to turn it on in
> mac80211 if only software crypto is possible.

Err, no he didn't ... anyway we'll sort it out.

johannes

