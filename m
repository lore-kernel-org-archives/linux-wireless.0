Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA65C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 14:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C8292098A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 14:23:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C8292098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbeJCVLt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 17:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbeJCVLt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 17:11:49 -0400
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 47B113097026;
        Wed,  3 Oct 2018 14:23:13 +0000 (UTC)
Received: from localhost (unknown [10.40.205.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4A6F308BDAA;
        Wed,  3 Oct 2018 14:23:09 +0000 (UTC)
Date:   Wed, 3 Oct 2018 16:23:08 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: new mt76 usb crashes on device removal
Message-ID: <20181003142307.GD2250@redhat.com>
References: <20181003082309.GB2229@redhat.com>
 <20181003091536.GB27279@localhost.localdomain>
 <20181003102927.GA2250@redhat.com>
 <20181003140905.GF27279@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003140905.GF27279@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.24
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 03 Oct 2018 14:23:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 04:09:06PM +0200, Lorenzo Bianconi wrote:
> > It still crashes. You can not reproduce the problem ?
> > It's 100% reproducible for me, when I unplug mt76x0u or mt76x2 device.
> 
> Hi Stanislaw,
> 
> any news about the latest patchset I sent to fix that issue?

It fixed the problem, I thought you tested that by yourself.

Regards
Stanislaw
