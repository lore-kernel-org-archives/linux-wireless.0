Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.bemta7.messagelabs.com ([216.82.255.50]:37809 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754901Ab1FGAIV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 20:08:21 -0400
From: Viral Mehta <Viral.Mehta@lntinfotech.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 7 Jun 2011 05:31:27 +0530
Subject: bcm4329 background scanning
Message-ID: <D69C90565D53114396BF743585AF5A0912A8674CC4@VSHINMSMBX01.vshodc.lntinfotech.com> (sfid-20110607_020824_819211_5BC66275)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was looking at bcm4329 driver to understand how scanning is happening ?

I have two questions,
1. Does bcm4329 supports background scanning ?

from looking at the code, it looks like NO

2. Then when I am trying to connect from my Android phone to WiFi (which uses bcm4329 driver), it connects automatically to
     preconfigured APs. I do not see any code which initiates scanning ?

     Also is this related to patch here, [force scan when driver is loaded]
     https://www.codeaurora.org/gitweb/quic/le/?p=kernel/msm.git;a=commitdiff_plain;h=135bb396901003c7644bfc6004edec1f413b973a

I am also not able to understand the patch as well. I do not see where it is initiating the scan.
However, I am new to wireless driver things and may be my questions may sound very basic.

Thanks,
Viral

The contents of this e-mail and any attachment(s) may contain confidential or privileged information for the intended recipient(s). Unintended recipients are prohibited from taking action on the basis of information in this e-mail and  using or disseminating the information,  and must notify the sender and delete it from their system. L&T Infotech will not accept responsibility or liability for the accuracy or completeness of, or the presence of any virus or disabling code in this e-mail"

______________________________________________________________________
