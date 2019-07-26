Return-Path: <SRS0=cxAL=VX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0381C7618B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jul 2019 07:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 815F12189F
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jul 2019 07:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfGZHCI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Jul 2019 03:02:08 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44004 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfGZHCI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jul 2019 03:02:08 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hquEn-0006Qb-C1; Fri, 26 Jul 2019 09:01:57 +0200
Message-ID: <6d8000cbcaa5d1f87293f3a1c344fafc7489c7ec.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/3] Bluetooth: btintel: Add firmware lock function
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     Luciano Coelho <luciano.coelho@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Date:   Fri, 26 Jul 2019 09:01:56 +0200
In-Reply-To: <B50A91CA-7379-42F9-8335-8FE4A51BE66F@canonical.com> (sfid-20190717_160853_553608_F848C9E8)
References: <20190717074920.21624-1-kai.heng.feng@canonical.com>
         <7CE1949F-76D2-4D27-82B6-02124E62DF5C@holtmann.org>
         <B50A91CA-7379-42F9-8335-8FE4A51BE66F@canonical.com>
         (sfid-20190717_160853_553608_F848C9E8)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

[trimming CCs a bit]

> > so I am not in favor of this solution. The hardware guys should start  
> > looking into fixing the firmware loading and provide proper firmware that  
> > can be loaded at the same time.
> 
> Of course it’s much better to fix from hardware side.

I tried to ask around a bit, and am told that a firmware fix (to just
retry the relevant hardware block access) was made. I'll try to figure
out where/how it was (or wasn't?) released.

johannes

