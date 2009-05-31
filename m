Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:41112 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZEaMKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 08:10:51 -0400
Received: by fxm12 with SMTP id 12so5248431fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 05:10:52 -0700 (PDT)
Subject: Re: [Announce] Intel Wireless Multicomm 3200 WiFi driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1243752126.3623.375.camel@debian>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <20090526222433.GA23972@bombadil.infradead.org>
	 <1243736227.3623.180.camel@debian>
	 <43e72e890905302327x23d0479bkb825ea05832c5ffd@mail.gmail.com>
	 <1243752126.3623.375.camel@debian>
Content-Type: text/plain
Date: Sun, 31 May 2009 15:10:47 +0300
Message-Id: <1243771847.5248.10.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-05-31 at 14:42 +0800, Zhu Yi wrote:
> On Sun, 2009-05-31 at 14:27 +0800, Luis R. Rodriguez wrote:
> > 
> > What is the 11n configuration on these devices? Do they have 2
> > streams? Or are they just 1 stream?
> 
> It has 1x1, 1x2 and 2x2 on for both 20MHz and 40MHz channels. The
> firmware HT support is not quite ready at this point. So we haven't done
> anything 11n related in the driver yet.

I have small question:

This is a fullmac driver, thus if I understand correctly, it behaves on
the outside more like an Ethernet adapter.
This will mean that many things possible with normal softmac card won't
be possible, like sending raw packets, etc...
(and besides I belive that hardware is more or less the same, but more
functionality is pushed down to firmware, and more firmware code equals
to bigger probability of bugs that aren't possible to triage and solve
easily.

Does this device indicate that intel moves away from softmac devices, or
this is a device that will mostly be used in some dedicated market
sector (embedded devices for example)?


Best regards,
	Maxim Levitsky

