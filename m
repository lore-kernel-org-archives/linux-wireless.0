Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:2729 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZJTPOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 11:14:54 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Charles Gordon <digigordo@gmail.com>
Subject: Re: Rate information in ad-hoc and mesh mode
Date: Tue, 20 Oct 2009 17:14:34 +0200
Cc: linux-wireless@vger.kernel.org
References: <86201b3f0910200710u36557bf8uf5bc014b32b14d33@mail.gmail.com>
In-Reply-To: <86201b3f0910200710u36557bf8uf5bc014b32b14d33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910201714.34866.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I notice that the ieee80211_ioctl_giwrate function in wext.c only
> returns rate information for stations associated to an AP.  It does
> not return rate information for stations operating in ad-hoc mode or
> as a mesh point.  Is there a reason this function is not supported in
> those modes?  Is this a deliberate decision or just an oversight?

You need to give more context. What driver, what kernel?


A quick 

   ack-grep ieee80211_ioctl_giwrate include/net include/linux \
                                    net/wireless net/mac80211 \
                                    drivers/net/wireless

didn't reveal the function you've mentioned, at least not in the
current wireless-testing kernel.

-- 
http://www.holgerschurig.de
