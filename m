Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:42778 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2KDPSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2012 10:18:08 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so3635184lag.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2012 07:18:06 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 4 Nov 2012 16:18:06 +0100
Message-ID: <CAJZtC_ksyKZtOEye3xqTySKf49JTy5-=Jf=G1qvoPaexJCieTw@mail.gmail.com> (sfid-20121104_161822_798208_CDAFF88C)
Subject: 802.11h support?
From: Rene Bartsch <renne.bartsch@googlemail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

according to ETSI regulations, mesh-communities can only use 5500 MHz -
5700 MHz (channel 100 - 140) with Dynamic Frequency Selection and Transmit
Power Control for outdoor connections. But currently there seems to be no
support for DFS and TPC in the linux kernel, which is a big show-stopper
for mesh-communities.

Is 802.11h-development discontinued or is there any progress/support in the
kernel?

Best regards,

Rene Bartsch
