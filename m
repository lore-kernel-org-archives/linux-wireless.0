Return-Path: <SRS0=zMWk=BG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33708C433E4
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 14:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D0F52250E
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 14:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbgG0Owj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 27 Jul 2020 10:52:39 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:49920 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729015AbgG0Owj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Jul 2020 10:52:39 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 8B7171730851;
        Mon, 27 Jul 2020 14:52:38 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: help13_470362226f62
X-Filterd-Recvd-Size: 1689
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Mon, 27 Jul 2020 14:52:36 +0000 (UTC)
Message-ID: <6e0c07bc3d2f48d4a62a9e270366c536cfe56783.camel@perches.com>
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg
 uses
From:   Joe Perches <joe@perches.com>
To:     Pkshih <pkshih@realtek.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Date:   Mon, 27 Jul 2020 07:52:35 -0700
In-Reply-To: <1595840670.17671.4.camel@realtek.com>
References: <cover.1595706419.git.joe@perches.com>
         <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
         <1595830034.12227.7.camel@realtek.com>
         <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
         <1595840670.17671.4.camel@realtek.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-07-27 at 09:04 +0000, Pkshih wrote:
> So, I think you would like to have parenthesis intentionally.
> If so, 
> test1 ? : (test2 ? :)
> would be better.
> 
> 
> If not,
> test1 ? : test2 ? :
> may be what you want (without any parenthesis).

Use whatever style you like, it's unimportant to me
and it's not worth spending any real time on it.


