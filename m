Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4966 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbXL2EOv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2007 23:14:51 -0500
Subject: Re: [PATCH] Add Linksys WCF11 to hostap driver
From: Pavel Roskin <proski@gnu.org>
To: Marcin Juszkiewicz <openembedded@haerwu.biz>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	netdev@vger.kernel.org
In-Reply-To: <200712281416.59079.openembedded@haerwu.biz>
References: <200712281416.59079.openembedded@haerwu.biz>
Content-Type: text/plain
Date: Fri, 28 Dec 2007 23:14:49 -0500
Message-Id: <1198901689.2221.3.camel@dv> (sfid-20071229_041504_483538_65C32E15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

On Fri, 2007-12-28 at 14:16 +0100, Marcin Juszkiewicz wrote:

> +       PCMCIA_DEVICE_PROD_ID1234(
> +               "The Linksys Group, Inc.", "Wireless Network CF Card", "ISL37300P",
> +               "RevA",
> +               0xa5f472c2, 0x9c05598d, 0xc9049a39, 0x57a66194),

I would prefer that revisions are not used for card identification in
presence of the chip name.  It's not like RevB would need another driver
as long as "ISL37300P" is still a part of the PCMCIA ID.
PCMCIA_DEVICE_PROD_ID123 should be enough.

-- 
Regards,
Pavel Roskin
