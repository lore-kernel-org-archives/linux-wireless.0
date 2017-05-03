Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45370 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754030AbdECUdx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 16:33:53 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glkwg-linux-wireless@m.gmane.org>)
        id 1d60y0-0002Px-N2
        for linux-wireless@vger.kernel.org; Wed, 03 May 2017 22:33:44 +0200
To: linux-wireless@vger.kernel.org
From: Julien Cubizolles <j.cubizolles@free.fr>
Subject: Re: mwifiex won't connect to WPA2 anymore
Date: Wed, 03 May 2017 22:33:44 +0200
Message-ID: <87tw51y91z.fsf@free.fr> (sfid-20170503_223357_040334_10E977E2)
References: <87wpa3kxgi.fsf@free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julien Cubizolles <j.cubizolles@free.fr> writes:

> I can't connect anymore to my home wifi since upgrading my machine from
> Ubuntu 16.10 to Ubuntu 17.04.

It turns out that the problem lies with NetworkManager, I managed to get
the wifi working with wpa_supplicant.

Julien.
