Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:42802 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754556AbeBNIXp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 03:23:45 -0500
Received: by mail-lf0-f47.google.com with SMTP id w10so15516072lfc.9
        for <linux-wireless@vger.kernel.org>; Wed, 14 Feb 2018 00:23:44 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [Make-wifi-fast] [PATCH] mac80211: Adjust TSQ pacing shift
From: Jonathan Morton <chromatix99@gmail.com>
In-Reply-To: <41B51538-B1F5-4611-AAB4-923C585FF3DA@toke.dk>
Date: Wed, 14 Feb 2018 10:23:41 +0200
Cc: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        "make-wifi-fast@lists.bufferbloat.net"
        <make-wifi-fast@lists.bufferbloat.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-Id: <AF418EFD-681C-4845-A114-23F54F100A9D@gmail.com> (sfid-20180214_092348_920071_E87BDB46)
References: <20180202151105.30043-1-toke@toke.dk>
 <40f644f6-ecfa-c31b-ce98-3491c954d6b1@qti.qualcomm.com>
 <41B51538-B1F5-4611-AAB4-923C585FF3DA@toke.dk>
To: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 14 Feb, 2018, at 10:18 am, Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@toke.dk> wrote:
>=20
> Why does the CPU usage go up >7?

Just as a guess, it's generating extra packets which are then =
laboriously discarded and retransmitted.

 - Jonathan Morton
