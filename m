Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1542CC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 08:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4DA4214FF
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 08:49:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4DA4214FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbeJJQLB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 12:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbeJJQLB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 12:11:01 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B533C062ECA;
        Wed, 10 Oct 2018 08:49:52 +0000 (UTC)
Received: from localhost (unknown [10.43.2.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26286608E8;
        Wed, 10 Oct 2018 08:49:51 +0000 (UTC)
Date:   Wed, 10 Oct 2018 10:49:50 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] rt2x00: set registers based on current band
Message-ID: <20181010084949.GA3258@redhat.com>
References: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
 <20181009110017.GB9259@redhat.com>
 <CAKR_QVK_UF6OMg8RAh1jaMoO+xt3OKtM6Q++zAO+FHuyRKwzFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVK_UF6OMg8RAh1jaMoO+xt3OKtM6Q++zAO+FHuyRKwzFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 10 Oct 2018 08:49:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 10, 2018 at 12:14:28AM +0200, Tom Psyborg wrote:
> On 09/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > Patches 3-5 looks ok to me, I'll rebase and resend them.
> >
> > Thanks
> > Stanislaw
> >
> 
> and what about patches 1-2 ? did you find any regression?

I don't think they are correct nor needed. I belive you got
my comments on those patches.

Thanks
Stanislaw

