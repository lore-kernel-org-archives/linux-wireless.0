Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1DMVtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 17:49:02 -0400
Received: by bwz15 with SMTP id 15so948962bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2011 14:49:01 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [RFT] p54: implement multicast + arp req PS filter
Date: Thu, 14 Apr 2011 01:48:54 +0400
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <201104020058.17232.chunkeey@googlemail.com> <201104100154.37008.chunkeey@googlemail.com> <201104100441.37852.jcmvbkbc@gmail.com>
In-Reply-To: <201104100441.37852.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104140148.56798.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Christian.

> > > "sagred stuff" ?
> > yeah, it was a while ago... 
> > "p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)"
> > http://www.spinics.net/lists/linux-wireless/msg55967.html
> > 
> > AFAIK they have another p54spi firmware
> > "phy0: FW rev 2.19.0.0.A.14 Private - Softmac protocol 5.6"
> 
> Ok, I'll try to test it with firmware images other than nokia's native.

The results are the following:

2.19.0.0.A.14 -- ARP and multicast filters are completely ignored in both normal mode and PSM.
2.13.12.0.a.5.2 -- ARP and multicast filters are completely ignored in both normal mode and PSM.
2.13.0.0.a.23 -- ARP and multicast filters are completely ignored in both normal mode and PSM.
2.13.0.0.a.22.0 -- same as with nokia's native
2.13.0.0.a.13.14 -- ARP and multicast filters are completely ignored in both normal mode and PSM.

Thanks.
-- Max
