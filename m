Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:43950 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1HLC15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 22:27:57 -0400
Received: by iye16 with SMTP id 16so598268iye.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 19:27:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: robert@ocallahan.org
In-Reply-To: <CAJ-Vmont2OdEGFqBKOen8XW+fTvA2xBgVr1h9vSeOBcQrE_FxA@mail.gmail.com>
References: <CAOp6jLa2xGcyg-rmE78FTpi11SbBq+EkWhXc+5na5QuebuFSBg@mail.gmail.com>
	<CAJ-Vmont2OdEGFqBKOen8XW+fTvA2xBgVr1h9vSeOBcQrE_FxA@mail.gmail.com>
Date: Fri, 12 Aug 2011 14:27:56 +1200
Message-ID: <CAOp6jLbp_Fvf8u9CxdhsK0vqJTHvhean7qp+vumuM+S_3-PApA@mail.gmail.com> (sfid-20110812_042800_290421_A0C1B19C)
Subject: Re: [ath9k-devel] Packet loss regression with Atheros AR9280 adapter
From: "Robert O'Callahan" <robert@ocallahan.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2011 at 2:25 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 11 August 2011 21:53, Robert O'Callahan <robert@ocallahan.org> wrote:
> > Running Fedora 15's 2.6.40 kernel with compat-wireless (built from August 8
> > tarball), I get persistent and quite severe packet loss with the AR9280 on
> > my desktop machine. This started happening since I upgraded from Fedora 13
> > to 15. Same box works fine running Windows 7, and other devices on the same
> > network have no problems. The AP is in the same room as the AR9280, about
> > three metres away. I have tried various versions of compat-wireless, passing
> > nohwcrypt=1 to ath9k, and limiting the rate to 1Mb/s, all to no avail.
> >
> > How can I help debug this? Last 500 lines of dmesg attached.
>
> Are you able to run an earlier version of compat-wireless, see if it
> is a problem?

Anything I can get building with this kernel, I guess. Any particular
version I should try?

Rob
--
"If we claim to be without sin, we deceive ourselves and the truth is
not in us. If we confess our sins, he is faithful and just and will
forgive us our sins and purify us from all unrighteousness. If we
claim we have not sinned, we make him out to be a liar and his word is
not in us." [1 John 1:8-10]
