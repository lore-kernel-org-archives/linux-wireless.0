Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36933 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbcCJOlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 09:41:21 -0500
Received: by mail-ig0-f173.google.com with SMTP id z8so19670668ige.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2016 06:41:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56E08615.9060208@lwfinger.net>
References: <56E08615.9060208@lwfinger.net>
Date: Thu, 10 Mar 2016 15:41:19 +0100
Message-ID: <CAGXE3d8cKcB-=Tep==YXq+Rs8c6Xho0vss2GtR0wTRDtBcPQ3g@mail.gmail.com> (sfid-20160310_154127_300533_0E1631C3)
Subject: Re: New firmware for RT2870
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>, dan.g.tob@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 9, 2016 at 9:22 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In https://bugzilla.kernel.org/show_bug.cgi?id=114151, the OP reports
> improved stability and performance for an RT5370 using a newer firmware that
> came with the driver CD. The logs show this to be version 0.36, whereas the
> version now in linux-firmware is version 0.29.
>
> I downloaded the firmware from b.k.o. It had very little effect on my
> no-name adapter with ID 148f:3070. It still gets ping losses of 10-15%.
>
> Should this new version be submitted to linux-firmware? Its provenance seems
> to be sketchy, but submission would likely be legal.

Version 0.36 can also be found in the vendor tarball on [1] even though it
references a different chip ...

So, in my opinion this should be safe from a legal point of view.

Helmut

[1] http://www.mediatek.com/en/downloads1/downloads/mt7612u/
