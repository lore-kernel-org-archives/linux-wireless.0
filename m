Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416E4C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 15:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 116762086A
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 15:20:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 116762086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388226AbeKPB2Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 20:28:16 -0500
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:41241 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388019AbeKPB2P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 20:28:15 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 2D47C100E86C3;
        Thu, 15 Nov 2018 15:19:59 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: bite24_1cc42e4188c25
X-Filterd-Recvd-Size: 2173
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Thu, 15 Nov 2018 15:19:57 +0000 (UTC)
Message-ID: <3946d05c0c026f3bdffaa35a686e5f12b8f3c59e.camel@perches.com>
Subject: Re: [RFC v4 08/13] rtw88: debug files
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com, sgruszka@redhat.com,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date:   Thu, 15 Nov 2018 07:19:56 -0800
In-Reply-To: <878t1ubf6i.fsf@codeaurora.org>
References: <1539421245-11847-1-git-send-email-yhchuang@realtek.com>
         <1539421245-11847-9-git-send-email-yhchuang@realtek.com>
         <a731948bf875867be4246b72a661ce71833620b8.camel@perches.com>
         <87y3b1vpjk.fsf@codeaurora.org>
         <0a41d14b9a964b6b7825bf5c55c32f35166354cd.camel@perches.com>
         <e85b7fa45cefc0bc3df15785f34792abe33f41c6.camel@perches.com>
         <878t1ubf6i.fsf@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-11-15 at 16:15 +0200, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > On Sat, 2018-10-13 at 13:28 -0700, Joe Perches wrote:
> > > On Sat, 2018-10-13 at 18:23 +0300, Kalle Valo wrote:
> > > > Joe Perches <joe@perches.com> writes:
> > []
> > > > > It's very unusual to have _all_ the logging under a CONFIG_<FOO>_DEBUG
> > > > > config guard flag.
> > > > 
> > > > For wireless drivers that is actually quite typical.
> > > 
> > > No, it isn't.
> > > 
> > > > IIRC at least ath6kl, ath9k and ath10k do that, most likely also others.
> > > 
> > > No, they don't.  Check again.
[]
> > Kalle, did I miss a reply here?
> 
> I didn't bother to waste my time after reading comments like "check
> again" and "look harder".

You are the maintainer here and you give advice that others are
likely to follow.

I was a bit frustrated after your fairly assertive, but wrong
statement that the other drivers you maintain do the same thing.



