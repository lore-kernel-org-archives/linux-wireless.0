Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:53263 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYBFPhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 10:37:37 -0500
Received: by wa-out-1112.google.com with SMTP id v27so515129wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2008 07:37:32 -0800 (PST)
Message-ID: <b6c5339f0802060737q5b3232c1u26311fe2bcfa7b48@mail.gmail.com> (sfid-20080206_153742_581970_25321EDF)
Date: Wed, 6 Feb 2008 10:37:32 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Tino Keitel" <tino.keitel@gmx.de>
Subject: Re: ath5k failure with 2.6.24-git14
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080206014131.9d489a34.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080205225746.GA4532@dose.home.local>
	 <20080206014131.9d489a34.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, 5 Feb 2008 23:57:46 +0100 Tino Keitel <tino.keitel@gmx.de> wrote:
>
> > Hi,
> >
> > I tried the current git (9ef9dc69d4167276c04590d67ee55de8380bc1ad) and
> > got the following error message from ath5k:
> >
> > ath5k_pci 0000:02:00.0: registered as 'phy0'
> > ath5k phy0: failed to resume the MAC Chip
> > ath5k_pci: probe of 0000:02:00.0 failed with error -5

Hi Tino,

I have the same chip and it is currently unsupported by ath5k.  See:

http://marc.info/?l=linux-wireless&m=120179743111458
