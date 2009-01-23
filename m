Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:7784 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763685AbZAWB3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 20:29:22 -0500
Received: by fk-out-0910.google.com with SMTP id f33so985438fkf.5
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 17:29:21 -0800 (PST)
Subject: Re: [BUG] latest wireless-testing (compat-wireless) doesn't work
 with iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1232672850.7913.6.camel@maxim-laptop>
References: <1232672850.7913.6.camel@maxim-laptop>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 03:29:16 +0200
Message-Id: <1232674156.4112.1.camel@maxim-laptop> (sfid-20090123_022928_770171_2E753963)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-23 at 03:07 +0200, Maxim Levitsky wrote:
> I currently use 2.6.28, and don't yet want to switch to 2.6.29-rc, so I
> installed vanilla 2.6.28, and compat-wireless of today on top of it
> only options I changed, were I enabled rfkill in iwl3945 and crda, which
> I did install.
> 
> device doesn't associate with my AP (even in open mode)
> 
> nothing suspicions in logs, just says it did associate and then it
> dropped.
> 
> btw, in last versions of iwwifi.git I noticed that hardware encryption
> doesn't work anymore, so I enabled swcrypto, now nether it works
> 
> Best regards,
> 	Maxim Levitsky
> 
I just installed it again with all default options, and still same thing
I also noticed wierd AP names like:

 wlan0: associate with AP ffff88005463a9e0

Best regards,
	Maxim Levitsky

