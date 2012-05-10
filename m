Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59476 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2EJNiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 09:38:10 -0400
Received: by qcro28 with SMTP id o28so1091403qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 06:38:09 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 10 May 2012 21:38:08 +0800
Message-ID: <CAG9cJmkDf6koV93NyOo2W8D7Y3G6tapQOucjW5M7FLPDnNhvKQ@mail.gmail.com> (sfid-20120510_153814_399868_D618DB42)
Subject: how to remove the b43
From: lina <lina.lastname@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The same question as I asked before (please see
https://lkml.org/lkml/2012/1/6/155)

I want to clear the
b43-fwcutter-015
broadcom-wl-*
and all it related.

The reason I want to clear is that today I installed the kernel  3.3.5,
but still keep the last version 3.2.5

I want to clear the b43 related in 3.2.5, and re-install in 3.3.5


Thanks ahead for your suggestions.

P.S I have done some robust blind clear, but
# lsmod
Module                  Size  Used by
b43                   353456  0
mac80211              381396  1 b43
cfg80211              178201  2 mac80211,b43
pcmcia                 40801  2 ssb,b43
pcmcia_core            18294  1 pcmcia

seems I have removed the compact-wireless

Sorry I do really lack understanding about what's going on.

Thanks for your patience,

Best regards,
