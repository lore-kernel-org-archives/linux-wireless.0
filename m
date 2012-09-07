Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50742 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2IGPrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 11:47:17 -0400
Received: by eekc1 with SMTP id c1so1255133eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 08:47:15 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] p54: connect to 11w protected networks
Date: Fri, 7 Sep 2012 17:47:09 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net> <1346770467.3737.32.camel@jlt4.sipsolutions.net> <1347020234.4256.22.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347020234.4256.22.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201209071747.09666.chunkeey@googlemail.com> (sfid-20120907_174720_559870_3928AEA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 September 2012 14:17:14 Johannes Berg wrote:
> On Tue, 2012-09-04 at 16:54 +0200, Johannes Berg wrote:
>
> If you want this for your driver, I'll commit this:
> 
> http://p.sipsolutions.net/ea2e3dbe980f5db8.txt

Won't this totally disable the crypto offload
capabilities in AP mode?

I sort of prefer the nohwcrypt switch as it won't
interfere with running user setups as much (so we
don't burden systems like that weird telekom
streamin-box (Vision S100 - it's name I think)
that came with a p54pci minipci card and are
now used for different purposes by some.

Regards,
	Christian 
