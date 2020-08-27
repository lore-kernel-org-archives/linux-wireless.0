Return-Path: <SRS0=VRWf=CF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53C4C433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Aug 2020 11:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 889BD22CB3
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Aug 2020 11:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgH0KxE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Aug 2020 06:53:04 -0400
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:58514 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727066AbgH0Kwx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Aug 2020 06:52:53 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id BDA19181D3028;
        Thu, 27 Aug 2020 10:52:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: grip29_510e74c2706c
X-Filterd-Recvd-Size: 2584
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Thu, 27 Aug 2020 10:52:44 +0000 (UTC)
Message-ID: <1a23235e40b8089629ca784d8e33851b715a6599.camel@perches.com>
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg
 uses
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Date:   Thu, 27 Aug 2020 03:52:42 -0700
In-Reply-To: <87v9h4bfqz.fsf@codeaurora.org>
References: <cover.1595706419.git.joe@perches.com>
         <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
         <1595830034.12227.7.camel@realtek.com>
         <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
         <1595840670.17671.4.camel@realtek.com>
         <6e0c07bc3d2f48d4a62a9e270366c536cfe56783.camel@perches.com>
         <374359f9-8199-f4b9-0596-adc41c8c664f@lwfinger.net>
         <87v9h4bfqz.fsf@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-08-27 at 12:27 +0300, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> > On 7/27/20 9:52 AM, Joe Perches wrote:
> > > On Mon, 2020-07-27 at 09:04 +0000, Pkshih wrote:
> > > > So, I think you would like to have parenthesis intentionally.
> > > > If so,
> > > > test1 ? : (test2 ? :)
> > > > would be better.
> > > > 
> > > > 
> > > > If not,
> > > > test1 ? : test2 ? :
> > > > may be what you want (without any parenthesis).
> > > 
> > > Use whatever style you like, it's unimportant to me
> > > and it's not worth spending any real time on it.
> > 
> > If you are so busy, why did you jump in with patches that you knew I
> > was already working on? You knew because you critiqued my first
> > submission.
> 
> Yeah, I don't understand this either. First stepping on Larry's work and
> when after getting review comments claiming being busy and not caring is
> contradicting.

I didn't say I was busy, I said I didn't care.

And it's not stepping on anyone's work, it's
a trivial contribution.  Take it or not.
It's been months btw, the pace of the work isn't
particularly fast here.


