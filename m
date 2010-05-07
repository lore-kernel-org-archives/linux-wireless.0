Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12787 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0EGNYm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 09:24:42 -0400
Message-ID: <20100507092441.a7ewigtp7o4ow0gs-cebfxv@webmail.spamcop.net>
Date: Fri, 07 May 2010 09:24:41 -0400
From: Pavel Roskin <proski@gnu.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rt61pci: WEP broken in current wireless-testing
References: <20100506075157.whuptq9jgzkww4gs-cebfxv@webmail.spamcop.net>
	<20100506134335.GA4167@tuxdriver.com>
	<20100506211435.1nfaq83vkg4ccc0g-cebfxv@webmail.spamcop.net>
	<4BE3ABB0.9040506@gmail.com>
In-Reply-To: <4BE3ABB0.9040506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Gertjan van Wingerde <gwingerde@gmail.com>:

> It might be that one of my recent patches broke this. Can you try the
> attached patch?

I'm not sure I'll be able to test it before Monday.

But the patch looks good.  If the encrypted Tx is broken, it would be  
entirely consistent with my observations (monitor mode works,  
association works, but no data flowing).

-- 
Regards,
Pavel Roskin
