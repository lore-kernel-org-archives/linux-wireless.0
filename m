Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:58708 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbYFEOoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 10:44:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Felipe Maya" <felipe.maya@vexcorp.com>
Subject: Re: b43 opensource firmware for monitor mode
Date: Thu, 5 Jun 2008 16:43:58 +0200
Cc: "Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
References: <22744.201.36.143.231.1212676638.:mail@corporativo.mandic.com.br>
In-Reply-To: <22744.201.36.143.231.1212676638.:mail@corporativo.mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806051643.58818.mb@bu3sch.de> (sfid-20080605_164443_392249_8C7C35B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 June 2008 16:37:18 Felipe Maya wrote:
> 
> root@OpenWrt:/# insmod b43.ko fwpostfix=-open
> Segmentation fault
> root@OpenWrt:/# dmesg
> Unhandled kernel unaligned access[#1]:

Ah well. The alignment is not completely implemented, yet ;)
Working on that...

-- 
Greetings Michael.
