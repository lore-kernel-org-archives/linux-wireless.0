Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35809 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751617AbdBAOYf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 09:24:35 -0500
Received: by mail-io0-f169.google.com with SMTP id j18so157268145ioe.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2017 06:24:35 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?J=C3=B6rg_Pommnitz?= <j.pommnitz@gmail.com>
Date: Wed, 1 Feb 2017 15:24:33 +0100
Message-ID: <CAEvAWuH-HkC1VNbtLZdjtNQehcE2CR+k0RP=24xMx3TTxzFdUg@mail.gmail.com> (sfid-20170201_152438_772895_B51E2A0E)
Subject: Changing of WMM queue parameters forbidden for IBSS interfaces
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I'm trying to change the WMM parameters for an IBSS network. I'm
adding a command to set txq_params to iw. Sadly the current kernel
code explicitly denies this for interfaces other than AP and P2P (see
http://lxr.free-electrons.com/source/net/wireless/nl80211.c#L2279).

Is there a reason why this should not be done for IBSS interfaces?


Thanks in advance
  Joerg
