Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f44.google.com ([209.85.128.44]:40253 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3EHTX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 15:23:27 -0400
Received: by mail-qe0-f44.google.com with SMTP id s14so1381074qeb.3
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 12:23:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430DD2CA03F7@SC-VEXCH1.marvell.com>
References: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E0579DB@SC-VEXCH1.marvell.com>
	<CAMLZHHQ=BNuD0UmcV8pv=6phW=W-C5C7Af6n8tLWTrzyuzPQow@mail.gmail.com>
	<CAMLZHHQXY3OuWKr_K1B9-NmZFwCcQFPNTBoOkpvT9kxWJ=ixqQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E14FF4C@SC-VEXCH1.marvell.com>
	<CAMLZHHSHG2ySmW0ac6+M-7fOgNFrqXBf7=SXFFkWDrhwGwYKXQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E150221@SC-VEXCH1.marvell.com>
	<CAMLZHHThUxB_Vj4eOjq+61osUQ3CQ5UGgvrgZXE33oDD1N=YtA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E150A22@SC-VEXCH1.marvell.com>
	<CAMLZHHTNPBh3LDD0F2+zqSvUPmT6bhA8HLZvc1dTJmHGR8eVJg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E232E33@SC-VEXCH1.marvell.com>
	<CAMLZHHS7DOfRfpd-W2hVeJSvxVHNjm7SrxGXH=qLqaFt2sB+BA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430DD2C9FC92@SC-VEXCH1.marvell.com>
	<CAMLZHHQdBuy=7bBsifA4i5ZKQcjnEhKZqVumRE=qu+Jkn3dZug@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430DD2CA03F7@SC-VEXCH1.marvell.com>
Date: Wed, 8 May 2013 13:23:26 -0600
Message-ID: <CAMLZHHSZh7J-iA3aYwEFM5CsDpvystWTu8FfyysWckPcvv86Rg@mail.gmail.com> (sfid-20130508_212330_778646_563F4375)
Subject: Re: Memory leak in mwifiex_cfg80211_scan
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 8, 2013 at 11:58 AM, Bing Zhao <bzhao@marvell.com> wrote:
> Thanks for the comment. Please find attached updated patch.

This looks better, thanks.

Daniel
