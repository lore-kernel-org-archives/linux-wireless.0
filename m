Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:40707 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaGJUZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 16:25:08 -0400
Received: by mail-qa0-f51.google.com with SMTP id k15so93512qaq.38
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 13:25:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53BEF2A6.6050103@broadcom.com>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
 <1404980258-30853-30-git-send-email-teg@jklm.no> <53BEF2A6.6050103@broadcom.com>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 10 Jul 2014 22:24:46 +0200
Message-ID: <CAG-2HqVnUwPpRwRwNpMXVN4zP4k3zUvJX5E4p-roi6BKpHTgNQ@mail.gmail.com> (sfid-20140710_222512_801707_CCBF0512)
Subject: Re: [PATCH v7 29/33] net: brcmfmac - set name assign type
To: Arend van Spriel <arend@broadcom.com>
Cc: netdev <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	David Herrmann <dh.herrmann@gmail.com>,
	Kay Sievers <kay@vrfy.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	John Linville <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2014 at 10:08 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 10-07-14 10:17, Tom Gundersen wrote:
>> The name is given by the firmware, so we assume it is predictable.
>
> How about the scenario where one would have multiple broadcom wifi
> devices in the system. Both driver instances would alloc_netdev with
> predictable but also the same ifname. Wondering whether we should ignore
> the firmware ifname altogether.

Hm, that would just fail irrespective of this patch, right? Sounds
like ignoring the firmware names is the right thing to do.

Cheers,

Tom
