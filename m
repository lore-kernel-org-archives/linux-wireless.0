Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:57136 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaETMc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 08:32:29 -0400
Received: by mail-qg0-f51.google.com with SMTP id q107so578591qgd.10
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 05:32:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGnRvurBpWcn6ToSVq5bJN=bOuz_8ej9QgcvX6SP97M1ndwCRA@mail.gmail.com>
References: <CAGnRvuq9pP3f+KiZAZ6Rpz-NKPqW9tnPRX4MmGZ6PK9PT3U_xA@mail.gmail.com>
 <546412005.18351359.1400528308190.JavaMail.root@zimbra65-e11.priv.proxad.net> <CAGnRvurBpWcn6ToSVq5bJN=bOuz_8ej9QgcvX6SP97M1ndwCRA@mail.gmail.com>
From: Henning Rogge <hrogge@gmail.com>
Date: Tue, 20 May 2014 14:32:08 +0200
Message-ID: <CAGnRvup8OVnkTxxJzV5Pe88XNUFXXVh21tpgygS=f27Hux=uiQ@mail.gmail.com> (sfid-20140520_143232_873771_39875C41)
Subject: Re: 802.11s mode without HWMP
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

after spending a day reading through the 802.11s implementation of
Linux I have to admit I am lost...

I am using 802.11s bridged to ethernet on both wlan interfaces and it
works very well.

Unfortunately the cfg802.11 is not telling me which ethernet mac
address is behind which wifi mac address, something that has to be
known to the kernel to forward the bridged ethernet frames.

Is there a trick to get this information or is this just a missing
functionality in the cfg80211 API (or the "iw <mesh-if> mpath ..."
commands) ?

Henning Rogge
