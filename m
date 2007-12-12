Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:58075 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbXLLLQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 06:16:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Randy Cushman <rcushman_linux@roadrunner.com>
Subject: Re: BCM4306 Questions
Date: Wed, 12 Dec 2007 12:14:50 +0100
Cc: linux-wireless@vger.kernel.org
References: <475F2DAD.4000708@roadrunner.com>
In-Reply-To: <475F2DAD.4000708@roadrunner.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712121214.50522.mb@bu3sch.de> (sfid-20071212_111644_456258_93F7797A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 December 2007 01:39:09 Randy Cushman wrote:
> Recently I retrofitted my older HP laptop with a "Broadcom 802.11b/g 
> WLAN" miniPCI adapter.  The adapter works well with Windows XP.  Now I 
> would like to be able to use the adapter with Linux.
> 
> Question:  Is there any hope of using this adapter with a native driver,

Yes.
 
> Complication:  Neither bcm43xx-fwcutter nor b43-fwcutter recognizes the 
> latest driver I found at HP.  I figure it would be best for me to use 
> this firmware because this is the only driver that I have found to be 
> stable.

The driver stability is not related to the firmware.
You have to use this firmware:
http://linuxwireless.org/en/users/Drivers/b43#devicefirmware

> Question:  Could someone instruct a mere applications software engineer 
> on how to determine the values to insert into fwcutter_list.h to support 
> this driver (or provide documentation to this effect)?

No. Use the officially supported firmware.

-- 
Greetings Michael.
