Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53912 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3ISNVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 09:21:08 -0400
Received: by mail-wg0-f48.google.com with SMTP id n12so7897988wgh.15
        for <linux-wireless@vger.kernel.org>; Thu, 19 Sep 2013 06:21:07 -0700 (PDT)
Message-ID: <523AFA40.3000503@gmail.com> (sfid-20130919_152112_815898_19C0CD4E)
Date: Thu, 19 Sep 2013 15:21:04 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	fheinonen@gmail.com
Subject: Re: Zyxel NWD2705 testing
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Heinonen wrote:

> Hello, I have a Zyxel NWD2705 3x3 and according to my syslog based on
> rt3593 (0x0586, 0x3421). It is erroneously listed as rt3573 in the latest
> backports dev release. Is there a way I could help testing the rt3593
> chipset?

RT3573 and RT3593 devices are identified as 3593 because they use
the same chip.
But RT3573 brings a USB interface. And RT3593 is PCIe, still unsupported
by rt2x00.
