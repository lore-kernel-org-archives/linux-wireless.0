Return-Path: <SRS0=Yehs=D2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9405CC433DF
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Oct 2020 16:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FC8F22277
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Oct 2020 16:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730691AbgJSQzF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:55:05 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:57428 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730322AbgJSQzF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Oct 2020 12:55:05 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 965181802926E;
        Mon, 19 Oct 2020 16:55:03 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: air55_460ecc327238
X-Filterd-Recvd-Size: 2011
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Mon, 19 Oct 2020 16:55:01 +0000 (UTC)
Message-ID: <b92c72c591e6657ebb7f1984959607b3949ef58a.camel@perches.com>
Subject: Re: [PATCH] [v6] wireless: Initial driver submission for pureLiFi
 STA devices
From:   Joe Perches <joe@perches.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>,
        Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Mon, 19 Oct 2020 09:54:59 -0700
In-Reply-To: <LOYP265MB1918B212C618FF60333BFD85E01E0@LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM>
References: <20201019031744.17916-1-srini.raju@purelifi.com>
         <20201019083914.10932-1-srini.raju@purelifi.com>
        ,<CABPxzYJaB5_zZshs3JCnPDgUZQZc+XRN+DuE3BjGjJKsiJh0uA@mail.gmail.com>
         <LOYP265MB1918B212C618FF60333BFD85E01E0@LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-10-19 at 16:40 +0000, Srinivasan Raju wrote:
> > Overall, there are many magic numbers without comments, this makes it hard to
> > understand the code. Using defines with proper naming helps and for 802.11 stuff
> > can use ieee80211_*/IEEE80211_* should be used.
> 
> Thanks for your comments Krishna, will work on them.

When you do, please start adding
changelog information below the
---
line to your patches.

It's quite a chore to figure out
what changed between revisions.


