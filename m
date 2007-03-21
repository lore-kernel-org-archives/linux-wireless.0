Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:59424 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbXCUEHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 00:07:33 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HTs4q-0001qg-WB
	for linux-wireless@vger.kernel.org; Wed, 21 Mar 2007 00:05:33 -0400
Subject: Re: wireless chipsets not supported by current wireless tree
From: Pavel Roskin <proski@gnu.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070316224417.792d77d6@oldman>
References: <20070316224417.792d77d6@oldman>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 00:07:27 -0400
Message-Id: <1174450047.9513.36.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-03-16 at 22:44 -0700, Stephen Hemminger wrote:
> Anyone keep a list of the important chips not supported by the current
> wireless tree? I know about Atheros, and the upcoming Marvell stuff but
> what about the others.

I'm not aware of such list.  I think it could be placed on
http://linuxwireless.org/

Just off the top of my head:

No known drivers:

Airgo
Atheros draft-802.11n PCI
Atheros USB

Vendor drivers in unusable condition (importance is arguable):

Hermes 2/2.5
Am1771

Drivers outside the tree:

Intel ipw3945
rtl818x PCI
Atmel USB

Drivers in the tree but currently unusable:

rt61

This list may be helpful, but most chipsets listed there are obsolete:
http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Linux.Wireless.drivers.html

-- 
Regards,
Pavel Roskin

