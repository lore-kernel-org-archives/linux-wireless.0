Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58333 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdIUPxy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 11:53:54 -0400
Received: from mail-lf0-f71.google.com ([209.85.215.71])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <dariusz.gadomski@canonical.com>)
        id 1dv3nV-0003VH-GN
        for linux-wireless@vger.kernel.org; Thu, 21 Sep 2017 15:53:53 +0000
Received: by mail-lf0-f71.google.com with SMTP id l196so4501286lfl.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2017 08:53:53 -0700 (PDT)
Date: Thu, 21 Sep 2017 17:53:48 +0200
From: Dariusz Gadomski <dariusz.gadomski@canonical.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: Cisco's Wi-Fi Direct Client Policy and iwlwifi (8260)
Message-ID: <20170921155348.fcos6iootplin6uj@leonard> (sfid-20170921_175358_976241_0546F94A)
References: <20170818124800.q4r6xtflexkbetzq@leonard>
 <1503076588.15969.320.camel@coelho.fi>
 <1503076802.15969.322.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1503076802.15969.322.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 18, 2017 at 08:20:02PM +0300, Luca Coelho wrote:
Hello Luca,

Thank you and Johannes for looking into this.

> > I'll try to dig the thread I had about this and take it again with our
> > system engineers to hear what they have to say about it.

Any news about that thread by any chance?

> > In the meantime, I think it would be helpful if you could contact Cisco
> > about this issue as well.

I heard from them that since there's a P2P IE transmitted from the
client then the behavior is correct. They recommended switching the
option in the AP to xconnect-not-allow which is supposed to allow
P2P-capable devices to associate as long as they won't use P2P
functionality.

> Also, as a workaround if you are really not interested in using P2P is
> to start wpa_supplicant with “p2p_disabled=1” in the configuration. 
> This should prevent the P2P IE from being sent.

Unfortunately that didn't help. Although I was not able to run any
P2P-specific commands in wpa_cli (e.g. p2p_find, p2p_listen all
return FAIL) connecting to the AP in question kept failing.
Do you have any further hints on debugging this?

> --
> Cheers,
> Luca.

Thanks!
Dariusz
