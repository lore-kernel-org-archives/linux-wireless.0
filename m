Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4A9C433DB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Jan 2021 11:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F49322A83
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Jan 2021 11:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbhAEL4X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Jan 2021 06:56:23 -0500
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:35568 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726074AbhAEL4X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jan 2021 06:56:23 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id C3DED12FB;
        Tue,  5 Jan 2021 11:55:41 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: talk84_2e09490274d8
X-Filterd-Recvd-Size: 1813
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Tue,  5 Jan 2021 11:55:39 +0000 (UTC)
Message-ID: <d6ee8f44f9ca285f17bdec972bcd0abb89fe64d6.camel@perches.com>
Subject: Re: [PATCH] drivers: net: wireless: realtek: Fix the word
 association defautly de-faulty
From:   Joe Perches <joe@perches.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Julian Calaby <julian.calaby@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        zhengbin13@huawei.com, baijiaju1990@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date:   Tue, 05 Jan 2021 03:55:38 -0800
In-Reply-To: <X/RQeqAikxaCO2o0@Gentoo>
References: <20210105101738.13072-1-unixbhaskar@gmail.com>
         <CAGRGNgX-JSPW8LSmAUbm=2jkx+K4EYdntCq6P2i8td0TUk7Nww@mail.gmail.com>
         <X/RD/pll4UoRJG0w@Gentoo>
         <CAGRGNgVHcOjt4at+tzgrPxn=04_Y3b16pihDw6xucg4Eh1GFSA@mail.gmail.com>
         <X/RQeqAikxaCO2o0@Gentoo>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2021-01-05 at 17:11 +0530, Bhaskar Chowdhury wrote:
> On 22:24 Tue 05 Jan 2021, Julian Calaby wrote:
> > Hi Bhaskar,
[]
> > and your change is just making this comment worse.
> really??? Not sure about it.

I agree with Julian.  I'm fairly sure it's worse.
The change you suggest doesn't parse well and is extremely odd.
If you _really_ want to just change this use (and the others),
I repeat his suggestion of "by default".


