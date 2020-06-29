Return-Path: <SRS0=lFlT=AK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54363C433E1
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Jun 2020 20:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36E34206F1
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Jun 2020 20:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgF2UzQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:55:16 -0400
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:59408 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731296AbgF2TNM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jun 2020 15:13:12 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave03.hostedemail.com (Postfix) with ESMTP id D923D180178AE
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2020 06:18:03 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id A7B0A1802912C;
        Mon, 29 Jun 2020 06:18:03 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: jump22_500d9c826e6d
X-Filterd-Recvd-Size: 1439
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Mon, 29 Jun 2020 06:18:02 +0000 (UTC)
Message-ID: <300f12f5c266cb0940dfeee94dd13d42851ccdea.camel@perches.com>
Subject: Re: [PATCH 2/2] rtlwifi: 8821ae: remove unused path B parameters
 from swing table
From:   Joe Perches <joe@perches.com>
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Date:   Sun, 28 Jun 2020 23:18:01 -0700
In-Reply-To: <1593410915.25527.3.camel@realtek.com>
References: <20200629032937.17374-1-pkshih@realtek.com>
         <20200629032937.17374-2-pkshih@realtek.com>
         <be95d3c3e40e3670ed368b0df4ba397a@perches.com>
         <1593410915.25527.3.camel@realtek.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-06-29 at 06:09 +0000, Pkshih wrote:
> On Sun, 2020-06-28 at 22:21 -0700, Joe Perches wrote:
> > On 2020-06-28 20:29, pkshih@realtek.com wrote:
> > > From: Ping-Ke Shih <pkshih@realtek.com>
> > >  
> > > 8821AE is a 1x1 chip, so swing parameters for path B aren't necessary.
> > 
> > Then all the now unused arrays could be removed as well.
> > 
> My gcc doesn't warn this. Could I know how you find them?

Logic then inspection.


