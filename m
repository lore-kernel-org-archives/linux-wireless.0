Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:64111 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab3GJQnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 12:43:13 -0400
Received: by mail-ve0-f182.google.com with SMTP id ox1so6095116veb.41
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jul 2013 09:43:12 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 10 Jul 2013 11:43:12 -0500
Message-ID: <CAJ8GFOg9c78f3ivnSiX1o2TCTPa2B3D_01Tiki-cK1=tgghuhQ@mail.gmail.com> (sfid-20130710_184316_774319_905FF959)
Subject: Baseband watchdog timer tripping on AR9342
From: Harshal Chhaya <harshal@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On an AR9342-based AP, we see non-zero counts for
RESET_TYPE_BB_WATCHDOG and RESET_TYPE_BEACON_STUCK when trying to do
large uplink transfers from ~60 clients with some of them 30-40 ft
away.

All the other reset types have a count of zero.

These resets cause all the clients to disconnect.

Any ideas on how to avoid these resets and the subsequent disconnections?

Thanks,
- Harshal
