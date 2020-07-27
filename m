Return-Path: <SRS0=zMWk=BG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873B9C433E4
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 16:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4E0206E7
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 16:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731352AbgG0Qd7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 27 Jul 2020 12:33:59 -0400
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:34052 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729315AbgG0Qd7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Jul 2020 12:33:59 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 87C41181D3026;
        Mon, 27 Jul 2020 16:33:58 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: time94_1817cae26f62
X-Filterd-Recvd-Size: 2286
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Mon, 27 Jul 2020 16:33:56 +0000 (UTC)
Message-ID: <f5162c93f70b9f47314eda2403b80816d12ce7e0.camel@perches.com>
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg
 uses
From:   Joe Perches <joe@perches.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Date:   Mon, 27 Jul 2020 09:33:55 -0700
In-Reply-To: <374359f9-8199-f4b9-0596-adc41c8c664f@lwfinger.net>
References: <cover.1595706419.git.joe@perches.com>
         <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
         <1595830034.12227.7.camel@realtek.com>
         <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
         <1595840670.17671.4.camel@realtek.com>
         <6e0c07bc3d2f48d4a62a9e270366c536cfe56783.camel@perches.com>
         <374359f9-8199-f4b9-0596-adc41c8c664f@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-07-27 at 11:25 -0500, Larry Finger wrote:
> On 7/27/20 9:52 AM, Joe Perches wrote:
> > On Mon, 2020-07-27 at 09:04 +0000, Pkshih wrote:
> > > So, I think you would like to have parenthesis intentionally.
> > > If so,
> > > test1 ? : (test2 ? :)
> > > would be better.
> > > 
> > > 
> > > If not,
> > > test1 ? : test2 ? :
> > > may be what you want (without any parenthesis).
> > 
> > Use whatever style you like, it's unimportant to me
> > and it's not worth spending any real time on it.
> 
> If you are so busy, why did you jump in with patches that you knew I was already 
> working on? You knew because you critiqued my first submission.

Because it was over a week and you didn't reply
to my original message nor did you cc me on any
changes you made to your patch?

I can't read every patch I'm not cc'd on.


