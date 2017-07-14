Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 87-127-66-237.static.enta.net ([87.127.66.237]:59509 "EHLO
        broadwell.dga.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdGQLsl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 07:48:41 -0400
Received: from [192.160.109.200] (helo=mail.linkchoose.co.uk)
        by tardis.dga.co.uk with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.84)
        (envelope-from <david.goodenough@linkchoose.co.uk>)
        id 1dW0Ru-0003pY-7w
        for linux-wireless@vger.kernel.org; Fri, 14 Jul 2017 14:16:02 +0100
Received: from stargate.local ([192.168.0.64] helo=stargate.localnet)
        by mail.linkchoose.co.uk with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <david.goodenough@linkchoose.co.uk>)
        id 1dW0q4-0001kT-8X
        for linux-wireless@vger.kernel.org; Fri, 14 Jul 2017 14:41:00 +0100
From: David Goodenough <david.goodenough@linkchoose.co.uk>
To: linux-wireless@vger.kernel.org
Subject: Intel 8265/8275 microcode
Date: Fri, 14 Jul 2017 14:15:40 +0100
Message-ID: <16310088.uhQu2hRbdQ@stargate> (sfid-20170717_134844_975406_DE272064)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a laptop which reports the wifi adapter to be an 8265/8275 rev 78 
and the driver complains that it can not find:-

iwlwifi-8265-23.ucode
iwlwifi-8265-24.ucode
iwlwifi-8265-25.ucode
iwlwifi-8265-26.ucode

and they not appear to be in the kernel.org github.  Where do I find
them and could they be added to github?

Thank you

David
