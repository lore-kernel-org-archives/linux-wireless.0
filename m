Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64394 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1DOJlh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 05:41:37 -0400
Received: by qwk3 with SMTP id 3so1338995qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2011 02:41:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikUS=G3J7C3HSNnHJGGTeZ9OR+qPw@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
	<BANLkTi=HaJ0ZrtmDo=wwBOrEweZrjHqWXw@mail.gmail.com>
	<BANLkTikyCcN6dP0DiQboXv4rDoSGqTDdTA@mail.gmail.com>
	<201104142251.10881.chunkeey@googlemail.com>
	<BANLkTinpodW6rjQ7GTOFkVV7L=KG8kuS7Q@mail.gmail.com>
	<BANLkTimw4SOgMHXNJmue-JsbXD4QuMjmgQ@mail.gmail.com>
	<BANLkTimmdRi_CmwgH14aJbQJecYav-4r8Q@mail.gmail.com>
	<BANLkTimfifFrKdgYuMvAMhSGKAJXu3W9mA@mail.gmail.com>
	<BANLkTik5jzVUHaPKm6Tu-shDOwLkcyUt0A@mail.gmail.com>
	<BANLkTikUS=G3J7C3HSNnHJGGTeZ9OR+qPw@mail.gmail.com>
Date: Fri, 15 Apr 2011 11:41:36 +0200
Message-ID: <BANLkTik_y=LAzYJUEyrggeQyyJm2_FgnBQ@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Damian Lesiuk <lesiuk@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 15, 2011 at 11:26 AM, Damian Lesiuk <lesiuk@gmail.com> wrote:
> After aplying this patch:
>
> Station 74:f0:6d:33:ea:00 (on wlan0)
>        inactive time:  50 ms
>        rx bytes:       4501008
>        rx packets:     45502
>        tx bytes:       123883066
>        tx packets:     83649
>        signal:         -32 dBm
>        tx bitrate:     150.0 MBit/s MCS 7 40Mhz short GI
>
> I can get now 55 mbps.
> It's max for me?

Maybe, depending on the channel conditions, interferences etc.

Also, how do you measure the throughput? Is it TCP or UDP? Do you
use any higher level protocols like SMB, NFS or FTP?

Helmut
