Return-Path: <SRS0=HArj=VS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400CBC76191
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Jul 2019 16:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EEA821743
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Jul 2019 16:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfGUQ4Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 21 Jul 2019 12:56:24 -0400
Received: from smtprelay0051.hostedemail.com ([216.40.44.51]:50311 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725943AbfGUQ4Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Jul 2019 12:56:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 11E49100E86C1;
        Sun, 21 Jul 2019 16:56:23 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: mist98_1a5900528f025
X-Filterd-Recvd-Size: 1887
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Sun, 21 Jul 2019 16:56:20 +0000 (UTC)
Message-ID: <3a2d6eb86fc211002607aad12b35648736e46342.camel@perches.com>
Subject: Re: [PATCH 1/3] mt76: fix checkpatch warnings and errors
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Roy Luo <royluo@google.com>, YF Luo <yf.luo@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 21 Jul 2019 09:56:18 -0700
In-Reply-To: <87blxnsmxm.fsf@purkki.adurom.net>
References: <50d28c9b0f9e7d6b277d36fc93f55142d7535259.1563518381.git.ryder.lee@mediatek.com>
         <87blxnsmxm.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-07-21 at 13:26 +0300, Kalle Valo wrote:
> Ryder Lee <ryder.lee@mediatek.com> writes:
> > Fix warnings and errors as much as possible.
[]
> This is way too big and the commit log is too vague, please fix one
> problem at a time and describe in the commit log what you fixed.

Hello Ryder.

One option is to perform all the whitespace corrections
in a single patch and then show that the object files
have not changed.

I posted a trivial script several years ago that might
be of some help here.

https://lore.kernel.org/lkml/1405128087.6751.12.camel@joe-AO725/

It trivially reformats using checkpatch and produces a
possible set of changes that can be used to update a
git tree.


