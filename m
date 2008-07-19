Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:36108 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbYGSNlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 09:41:09 -0400
Received: by ik-out-1112.google.com with SMTP id c28so434408ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 06:41:07 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: Re: Please pull 'upstream' branch of rt2x00
Date: Sat, 19 Jul 2008 15:55:46 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807182043.08990.IvDoorn@gmail.com>
In-Reply-To: <200807182043.08990.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807191555.46700.IvDoorn@gmail.com> (sfid-20080719_154123_975411_19506E00)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Please wait with pulling from rt2x00.git,
updated patches are coming in a few moments,
I just noticed some cleanups which should be made
in several patches, and I'll incorporate the suggestion
from Johannes regarding the EIFS.

Sorry for the noise. ;)

Ivo

> Here is the latest update for rt2x00
> 
> I think all patches qualify for 2.6.27, 
> with the exception for first 2 patches:
>       rt2x00: Remove duplicate declaration
>       rt2x00: Fix EIFS timing value
> but those are one-liners and have little impact.
> 
> The 3 patches from Iwo are the most important ones,
> since that fixes a major bug in the beacon handling for the
> USB drivers. The 3 patches are a bit big, but without them
> beaconing simply won't work.
> 
> Ivo
> 
> ---
> The following changes since commit a520bdbe7d344296482f9355e29b0018ea58760f:
>   John W. Linville (1):
>         iwl-scan.c: fixup merge damage in wireless-testing#master
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ ..BRANCH.NOT.VERIFIED..
> 
> Ivo van Doorn (3):
>       rt2x00: Remove duplicate declaration
>       rt2x00: Fix EIFS timing value
>       rt2x00: Fix GCC warning because aifs is now unsigned
> 
> Iwo Mergler (3):
>       rt2x00: Support for large vendor requests
>       rt2x00: Large vendor requests for rt73usb firmware upload and beacons
>       rt2x00: Fix the beacon length bug
> 
>  drivers/net/wireless/rt2x00/rt2500usb.c |   12 +++++++
>  drivers/net/wireless/rt2x00/rt2x00.h    |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00lib.h |    7 ----
>  drivers/net/wireless/rt2x00/rt2x00mac.c |    5 +--
>  drivers/net/wireless/rt2x00/rt2x00usb.c |   33 ++++++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2x00usb.h |   22 ++++++++++++-
>  drivers/net/wireless/rt2x00/rt73usb.c   |   50 ++++++++++++------------------
>  7 files changed, 87 insertions(+), 44 deletions(-)
> 


