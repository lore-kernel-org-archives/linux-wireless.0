Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:52452 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653Ab3EHXbD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 19:31:03 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 8 May 2013 16:27:18 -0700
Subject: RE: Memory leak in mwifiex_cfg80211_scan
Message-ID: <477F20668A386D41ADCC57781B1F70430DD2CA056A@SC-VEXCH1.marvell.com> (sfid-20130509_013109_990760_205B2880)
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
 <CAMLZHHSZh7J-iA3aYwEFM5CsDpvystWTu8FfyysWckPcvv86Rg@mail.gmail.com>
In-Reply-To: <CAMLZHHSZh7J-iA3aYwEFM5CsDpvystWTu8FfyysWckPcvv86Rg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> > Thanks for the comment. Please find attached updated patch.
> 
> This looks better, thanks.

I will post these patches to the list after the 3.10 merge window.

905c907 mwifiex: scan delay timer cleanup in unload path
a11b504 mwifiex: rename mwifiex_free_adapter() routine in init.c
7841fa6 mwifiex: remove global user_scan_cfg variable

Thanks,
Bing

> 
> Daniel
