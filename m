Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43050 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab2IQWV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 18:21:57 -0400
MIME-Version: 1.0
In-Reply-To: <20566.39957.867109.459668@gargle.gargle.HOWL>
References: <20566.39957.867109.459668@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 17 Sep 2012 15:21:35 -0700
Message-ID: <CAB=NE6W9O-XvQUJgyfVgNtrNH6P-U57oMD+ptNGFid4bqZqv-Q@mail.gmail.com> (sfid-20120918_002201_613021_AE21EC03)
Subject: Re: [PATCH 0/3] Patches for compat 3.6.y
To: Sujith Manoharan <c_manoha@qualcomm.com>
Cc: linux-wireless@vger.kernel.org, backports@vger.kernel.org,
	Konstantin Ryabitsev <mricon@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 16, 2012 at 8:42 PM, Sujith Manoharan <c_manoha@qualcomm.com> wrote:
> Hi,
>
> These patches are for the 3.6.y branch in compat-drivers.
>
> Sujith
>
> Sujith Manoharan (3):
>   compat-drivers: Add pending stable patches
>   compat-drivers: Add new cherry picked patches
>   compat-drivers: Add linux-next pending patches

Great thanks, applied and pushed!

v3.6-rc6 was pushed out recently as well, and I updated the trees to
reflect that. Based on that and your patches I've kicked out a new set
of first tarballs based on v3.6-rc1. These releases did not have any
pending-stable/ patches as in between v3.6-rc6..next-20120917 and as
such there are no "-s" releases.

http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/compat-wireless-3.6-rc6-1.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/compat-wireless-3.6-rc6-1-n.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/compat-wireless-3.6-rc6-1-np.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.6/compat-wireless-3.6-rc6-1-npc.tar.bz2

Legend

Extra flag meanings:

-s - get and apply pending-stable/ from linux-next.git
-n - apply the patches linux-next-cherry-picks/ directory
-p - apply the patches on the linux-next-pending/ directory
-c - apply the patches on the crap/ directory

When no flags are used it means a vanilla release with 0 delta.

The respective ckmake logs for all releases will be uploaded in about
2-3 hours, but before tagging a release I did run ckmake test against
the -snpc release and everything went fine so I don't suspect issues
with the rest of the releases.

I should note that v3.6 releases will be the last set of release
hosted on orbit-lab.org and named as compat-wireless, after this, as
of v3.7, releases will be hosted on kernel.org and branded under
compat-drivers.

  Luis
