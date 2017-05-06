Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:12230 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751575AbdEFIlx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 May 2017 04:41:53 -0400
From: Julien Cubizolles <j.cubizolles@free.fr>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mwifiex won't connect to WPA2 anymore
References: <87wpa3kxgi.fsf@free.fr> <87tw51y91z.fsf@free.fr>
        <1493844237.5647.9.camel@redhat.com> <87a86sfh2e.fsf@free.fr>
        <1493948347.26081.1.camel@redhat.com>
Date: Sat, 06 May 2017 10:41:51 +0200
In-Reply-To: <1493948347.26081.1.camel@redhat.com> (Dan Williams's message of
        "Thu, 04 May 2017 20:39:07 -0500")
Message-ID: <87mvaq4bsg.fsf@free.fr> (sfid-20170506_104157_150589_02203C04)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:


> Just to test, could you add:
>
> auth_alg=OPEN
> key_mgmt=WPA-PSK
> scan_ssid=1
>
> to the block and retry with the supplicant?  I don't know why those
> would make a difference but they might.

They don't: wpa_supplicant still connects with these settings.
