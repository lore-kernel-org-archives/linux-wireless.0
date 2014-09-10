Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:53443 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaIJOOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 10:14:45 -0400
Received: by mail-ig0-f175.google.com with SMTP id uq10so6559824igb.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 Sep 2014 07:14:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54100F0E.8030204@broadcom.com>
References: <540FA8D9.2070803@netcommwireless.com>
	<54100F0E.8030204@broadcom.com>
Date: Wed, 10 Sep 2014 16:14:44 +0200
Message-ID: <CAGXE3d9FRLOPQ1pO6WFWy4FF67PGbo5ztfhLELydq3k410731w@mail.gmail.com> (sfid-20140910_161457_309066_1CE2D3EF)
Subject: Re: Not reaching optimum speeds with IEEE 802.11n
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Sourav <sourav.chakraborty@netcommwireless.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 10, 2014 at 10:42 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 09/10/14 03:26, Sourav wrote:
>> We are using Ralink chip Rt3072L (using rt2800usb drivers rt2800usb.c),

The Ralink USB hardware is quite bad in reporting TX status and as
such minstrel_ht cannot do proper rate selection.
If you watch the rc stats at
/sys/kernel/debug/ieee80211/phy0/netdev\:wlan0-0/stations/xx:xx:xx:xx:xx:xx/rc_stats
you might see a lot of rate selection "hopping".

Regards.
Helmut
