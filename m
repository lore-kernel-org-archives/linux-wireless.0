Return-Path: <SRS0=CJfu=43=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCB3C10DCE
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Mar 2020 22:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CC6D222C3
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Mar 2020 22:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgCJWag (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Mar 2020 18:30:36 -0400
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:44498 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726273AbgCJWag (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Mar 2020 18:30:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 28BDA100F9379;
        Tue, 10 Mar 2020 22:30:35 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: cable45_3f2046163eb28
X-Filterd-Recvd-Size: 2301
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Tue, 10 Mar 2020 22:30:33 +0000 (UTC)
Message-ID: <8b6213e51131deacbdac29a8d9c088ae49933724.camel@perches.com>
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with
 flexible-array member
From:   Joe Perches <joe@perches.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Mar 2020 15:28:52 -0700
In-Reply-To: <c2aa4d8d-1c39-1903-2b49-382f2143e181@embeddedor.com>
References: <20200305111216.GA24982@embeddedor>
         <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
         <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
         <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
         <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com>
         <87r1y0nwip.fsf@kamboji.qca.qualcomm.com>
         <48ff1333-0a14-36d8-9565-a7f13a06c974@embeddedor.com>
         <021d1125-3ffd-39ef-395a-b796c527bde4@gmail.com>
         <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
         <937b0b529509ec1641453ef7c13f38e2d7cc813e.camel@perches.com>
         <c2aa4d8d-1c39-1903-2b49-382f2143e181@embeddedor.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-03-10 at 17:21 -0500, Gustavo A. R. Silva wrote:
> On 3/10/20 5:15 PM, Joe Perches wrote:
> > As far as I can tell, it doesn't actually make a difference as
> > all the compilers produce the same object code with either form.
> > 
> 
> That's precisely why we can implement these changes, cleanly(the fact
> that the compiler produces the same object code). So, the resulting
> object code is not the point here.

You are making Jes' point.

There's nothing wrong with making changes just for consistent
style across the kernel.

This change is exactly that.

I have no objection to this patch.

Jes does, though Jes is not a maintainer of this file.

I think "churn" arguments are overstated.

