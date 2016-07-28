Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34316 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbcG1ICe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 04:02:34 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 2AC24202A8
	for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2016 04:02:33 -0400 (EDT)
Message-Id: <1469692952.331455.679081257.3C81B1F3@webmail.messagingengine.com> (sfid-20160728_100238_835650_2A9D839C)
From: Kai Hendry <hendry@iki.fi>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: rfkill bound to a switch
Date: Thu, 28 Jul 2016 16:02:32 +0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

Since laptops typically have a toggle button for killing and enabled
wifi, how does one supposed to bind rfkill like a toggle?

I.e. knowing which state you are in so you can call {block,unblock}
accordingly?

Parsing event or list output seems non-trivial.


Kind regards,
