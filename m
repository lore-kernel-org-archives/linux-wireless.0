Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48644 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3LFJIu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 04:08:50 -0500
Received: by mail-wg0-f42.google.com with SMTP id a1so592935wgh.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Dec 2013 01:08:49 -0800 (PST)
Date: Fri, 6 Dec 2013 10:08:07 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net, j@w1.fi
Subject: Re: [PATCH v2] iw: add VHT MCS/NSS set support to set bitrates
Message-ID: <20131206090807.GA7049@magnum.frso.rivierawaves.com> (sfid-20131206_100856_658247_0C2CE036)
References: <1386234137-3531-1-git-send-email-janusz.dziedzic@tieto.com>
 <1386234137-3531-4-git-send-email-janusz.dziedzic@tieto.com>
 <20131205173013.GB3593@magnum.frso.rivierawaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20131205173013.GB3593@magnum.frso.rivierawaves.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 05, 2013 at 06:30:13PM +0100, Karl Beldan wrote:
> On Thu, Dec 05, 2013 at 10:02:17AM +0100, Janusz Dziedzic wrote:
> > mcs-2.4/mcs-5 rename to ht-mcs-2.4/ht-mcs-5
> > vht-mcs-2.4/vht-mcs-5 added
> > 
> Are 256-QAM MCSes regular on 2.4G ?
>  
For example, in
https://android.googlesource.com/kernel/common/+/a2951d66120cbd5ec6e8ea5cba81c107bc6382e8/drivers/net/wireless/bcmdhd/dhd_linux.c
there is:

#ifdef SUPPORT_2G_VHT
        uint32 vht_features = 0x3; /* 2G enable | rates all */

 
Karl
