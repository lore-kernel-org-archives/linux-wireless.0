Return-Path: <SRS0=CI53=33=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14840C352A2
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 12:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4D702082E
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 12:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgBGMID (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Feb 2020 07:08:03 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:44422 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgBGMID (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Feb 2020 07:08:03 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j02QT-008B8Y-F3; Fri, 07 Feb 2020 13:08:01 +0100
Message-ID: <5df476855946cd62f24fded6901ff56e0ceb066a.camel@sipsolutions.net>
Subject: Re: Adding 802.11ax decode to 'iw scan dump'  Checking for interest
 and looking for feedback.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Poole <dpoole@cradlepoint.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        David Poole <davep@mbuf.com>
Date:   Fri, 07 Feb 2020 13:08:00 +0100
In-Reply-To: <MWHPR12MB1533B5C250E9B35367EAF628D9330@MWHPR12MB1533.namprd12.prod.outlook.com> (sfid-20200119_191652_472695_3818EFD7)
References: <MWHPR12MB1533B5C250E9B35367EAF628D9330@MWHPR12MB1533.namprd12.prod.outlook.com>
         (sfid-20200119_191652_472695_3818EFD7)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2020-01-19 at 18:16 +0000, David Poole wrote:
> Hello.
> 
> Attached is a first pass of adding 802.11ax decode to iw scan.c

Adding that would be great, but not using wireshark (GPL2) code here.

johannes

