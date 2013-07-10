Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:38756 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab3GJRaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 13:30:24 -0400
Received: by mail-ve0-f174.google.com with SMTP id oz10so6251336veb.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jul 2013 10:30:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ8GFOg9c78f3ivnSiX1o2TCTPa2B3D_01Tiki-cK1=tgghuhQ@mail.gmail.com>
References: <CAJ8GFOg9c78f3ivnSiX1o2TCTPa2B3D_01Tiki-cK1=tgghuhQ@mail.gmail.com>
Date: Wed, 10 Jul 2013 12:30:23 -0500
Message-ID: <CAJ8GFOiHgBU-SYsrgSRr3Tx66eL3r9Lyjr5Zz2A+E2XqPshyFQ@mail.gmail.com> (sfid-20130710_193030_185934_8F47A101)
Subject: Re: Baseband watchdog timer tripping on AR9342
From: Harshal Chhaya <harshal@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 10, 2013 at 11:43 AM, Harshal Chhaya <harshal@gmail.com> wrote:
> On an AR9342-based AP, we see non-zero counts for
> RESET_TYPE_BB_WATCHDOG and RESET_TYPE_BEACON_STUCK when trying to do
> large uplink transfers from ~60 clients with some of them 30-40 ft
> away.
>
> All the other reset types have a count of zero.
>
> These resets cause all the clients to disconnect.
>
> Any ideas on how to avoid these resets and the subsequent disconnections?


I forgot to mention that there were three "Failed to stop TX DMA"
messages on the debug port which seem to map to the
RESET_TYPE_BB_WATCHDOG events.

Regards,
- Harshal
