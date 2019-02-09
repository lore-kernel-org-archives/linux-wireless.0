Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B667C169C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 03:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B76A20869
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 03:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfBIDAH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 22:00:07 -0500
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:51157 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726663AbfBIDAH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 22:00:07 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 113581802928B;
        Sat,  9 Feb 2019 03:00:06 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: jail67_1dda460afb243
X-Filterd-Recvd-Size: 1383
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Sat,  9 Feb 2019 03:00:05 +0000 (UTC)
Message-ID: <50b60844f3ac435a41ff99a3043ee10133e30870.camel@perches.com>
Subject: Re: [PATCH 00/13] rtlwifi: Replace old-style license info with SPDX
 form
From:   Joe Perches <joe@perches.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com
Date:   Fri, 08 Feb 2019 19:00:03 -0800
In-Reply-To: <20190208172209.28530-1-Larry.Finger@lwfinger.net>
References: <20190208172209.28530-1-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-02-08 at 11:21 -0600, Larry Finger wrote:
> These patches change all the license information from the old-stype format
> to the newer SPDX format. There are no code changes.

About some of the removals:

> Copyright(c) 2009-2012  Realtek Corporation.

I believe these copyright markings should _not_ be removed.

> - * Contact Information:
> - * wlanfae <wlanfae@realtek.com
> - * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
> - * Hsinchu 300, Taiwan.

Why take out the contact information?  Is it invalid?


