Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postout2.mail.lrz.de ([129.187.255.138]:53071 "EHLO
        postout2.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754499AbeDPJKh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 05:10:37 -0400
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
        by postout2.mail.lrz.de (Postfix) with ESMTP id 40Pj9X4kVDz10vq
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 11:04:00 +0200 (CEST)
Received: from postout2.mail.lrz.de ([127.0.0.1])
        by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id dhKvR1K565Pv for <linux-wireless@vger.kernel.org>;
        Mon, 16 Apr 2018 11:04:00 +0200 (CEST)
Received: from BADWLRZ-SWMBX08.ads.mwn.de (BADWLRZ-SWMBX08.ads.mwn.de [IPv6:2001:4ca0:0:108::164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBX08", Issuer "BADWLRZ-SWMBX08" (not verified))
        by postout2.mail.lrz.de (Postfix) with ESMTPS id 40Pj9X2xGfz10vx
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 11:04:00 +0200 (CEST)
From: "Wruck, Felix" <felix.wruck@tum.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k tracing implementation/extension
Date: Mon, 16 Apr 2018 09:03:59 +0000
Message-ID: <8701446877534ab7ac743fbf6bcc8593@tum.de> (sfid-20180416_111042_861720_39D66154)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
for an university project i needed to use the debugging mechanisms provided=
 by the ath9k driver.
However it seems that some options of the debug mask described on  https://=
wireless.wiki.kernel.org/en/users/drivers/ath9k/debug are currently not imp=
lemented, e.g. tracing the ATH_DBG_WMI option.

I implemented some functionality i needed for the project and now want to e=
xtend this and submit it as a patch.

As far as i've seen, the debugging mechanisms used in the ath9k and ath10k =
are quite different.
I'm considering porting the ath10k debugging mechanisms to ath9k.
(a module parameter for the debugging mask and the DEFINE_TRACE_EVENT(), DE=
CLARE_EVENT_CLASS() macros)

I wanted to ask if this is desired, or if you have suggestions, how to exte=
nd the current debugging/tracing functionality?

Best regards,
Felix=
