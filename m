Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55062 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1A0QhM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 11:37:12 -0500
Received: by qwa26 with SMTP id 26so2301650qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 08:37:12 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 27 Jan 2011 17:37:11 +0100
Message-ID: <AANLkTinrAgtjz-3Mv0ik9x6sRRvnvUQZn4jQX97mG7it@mail.gmail.com>
Subject: Mini PCIeWiFi card not detected in non-mini adapter
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've received mini PCIe adapter to PCIe x1 slot to test notebook cards
inserted into PC.  Unfortunately after inserting my Broadcom card to
it, it is not detected in "lspci" at all.

My WiFi card used to work in "native" slot inside notebook. So if
anything is broken, that would be PCIe x1 slot on motherboard or
adapter itself. I've tested V and GND pins in my PCIe x1 slot, all
work fine. I'll try get some other WiFi cards, to test my adapter
tomorrow.

However, maybe you have heard about some problems with such a
adapters? Can there be sth preventing my card from being detected,
visible?

-- 
Rafał
