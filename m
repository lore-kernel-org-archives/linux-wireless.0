Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB047C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80A7D2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:13:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80A7D2172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hadess.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbeI1Qge (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 12:36:34 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:40977 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728936AbeI1Qge (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 12:36:34 -0400
X-Originating-IP: 83.155.44.161
Received: from classic (mon69-7-83-155-44-161.fbx.proxad.net [83.155.44.161])
        (Authenticated sender: hadess@hadess.net)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 5393D240021;
        Fri, 28 Sep 2018 10:13:27 +0000 (UTC)
Message-ID: <2630d73557fb3fd82181bd70f8cf4e8d561287e3.camel@hadess.net>
Subject: Re: Problems and suggestions to the kernel module r8723bs
From:   Bastien Nocera <hadess@hadess.net>
To:     Simon Beginn <simonmicro@simonmicro.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Fri, 28 Sep 2018 12:13:27 +0200
In-Reply-To: <374c0f3a-aa89-18c5-cd53-0c395ff02a6d@simonmicro.de>
References: <83c86a2a-0d2a-8119-2831-e9cfab7a43d7@simonmicro.de>
         <f0b67da4-747a-08e3-9744-fce2c74aaddc@lwfinger.net>
         <6e27de67-739f-ee17-eb5f-efb079d1f37f@simonmicro.de>
         <7a47d05c-2f3b-e4d5-ccf1-5c2106d3c93d@lwfinger.net>
         <3a0468ee-e391-3b03-bfc5-36df484bce9d@simonmicro.de>
         <9a7105c0-fd23-c7ff-3e28-62533c24cdb9@lwfinger.net>
         <374c0f3a-aa89-18c5-cd53-0c395ff02a6d@simonmicro.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-09-28 at 12:02 +0200, Simon Beginn wrote:
> > 
<snip>
> > ccepted. Even if it had been correctly done, I would have NACKed
> > it.
> 
> Sry, would you reformulate this, please? I just can't 
> understand/determine what the word "NACKed" means in this situation 
> (Neither google or the raw translation helps me).

Not ACKnowledged, in a word, refused.

