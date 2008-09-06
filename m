Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54838 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbYIFKlr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 06:41:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: Speed enhancement for BCM4306/2
Date: Sat, 6 Sep 2008 12:41:19 +0200
Cc: gavron@wetwork.net, Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@berlios.de>
References: <48C1BA91.7050106@lwfinger.net> <48C20BD7.6080605@lwfinger.net> <48C20F64.1000700@wetwork.net>
In-Reply-To: <48C20F64.1000700@wetwork.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809061241.19599.mb@bu3sch.de> (sfid-20080906_124229_677126_6CFAECE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 06 September 2008 07:04:36 gavron@wetwork.net wrote:
> +    }
> +    if (phy->rev >= 2)
>          b43legacy_phy_write(dev, 0x047E, 0x0078);
>      }

Does this even compile?

-- 
Greetings Michael.
