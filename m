Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46648 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbYCXHfy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2008 03:35:54 -0400
Message-ID: <20080324033553.38eybyo3v8qok8oc@webmail.spamcop.net> (sfid-20080324_073558_278160_8B410C8D)
Date: Mon, 24 Mar 2008 03:35:53 -0400
From: Pavel Roskin <proski@gnu.org>
To: Adam Turk <bofh1234@hotmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re:
References: <BAY101-W143CDEC5E4B7194B35601EC8030@phx.gbl>
In-Reply-To: <BAY101-W143CDEC5E4B7194B35601EC8030@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Adam Turk <bofh1234@hotmail.com>:

>
> Hello,
>
> I just compiled 2.6.25-rc6 and got a bunch of warnings when I did   
> make modules_install. I am using a PC not a laptop so I don't bother  
>  compiling PCMCIA support.
>
> WARNING:   
> /lib/modules/2.6.25-rc6/updates/drivers/net/usb/rndis_host.ko needs   
> unknown symbol usbnet_skb_return

Just remove /lib/modules/2.6.25-rc6 and reinstall the modules.  It's  
probably modules installed by compat-wireless that were compiled for a  
kernel with the same version but different settings.

-- 
Regards,
Pavel Roskin
