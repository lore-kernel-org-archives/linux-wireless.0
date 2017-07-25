Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.phoenitydawn.de ([213.202.223.74]:42415 "EHLO
        mail.phoenitydawn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdGYGOf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 02:14:35 -0400
From: Daniel Roschka <danielroschka@phoenitydawn.de>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com, arend.vanspriel@broadcom.com
Subject: brcmfmac: BCM43602 in Touch Bar MacBook Pros not working properly
Date: Tue, 25 Jul 2017 08:07:45 +0200
Message-ID: <2355211.moJg6pnjHJ@buzzard> (sfid-20170725_081441_956632_6FFAB8AD)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

All Apple MacBook Pro models with Touch Bar contain a BCM43602 Wi-Fi chip. 
This chip isn't working properly. While it is properly detected by brcmfmac 
and even shows wifi networks nearby, connections only succeed when being very, 
very close to the AP. Also 5Ghz networks aren't visible at all. Further 
details are written down in an issue opened half a year ago, which hasn't seen 
much activity since: https://bugzilla.kernel.org/show_bug.cgi?id=193121

As previous MacBook Pros had similar problems (see
https://bugzilla.kernel.org/show_bug.cgi?id=100201 and
https://bugzilla.kernel.org/show_bug.cgi?id=103201), which got resolved by a 
firmware update, I suspect that could be the solution for the current problems 
as well.

Is there anybody here who could take a look at that? That would be highly 
appreciated.

Regards,
Daniel
