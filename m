Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36083 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1HLCZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 22:25:53 -0400
Received: by yxj19 with SMTP id 19so1712161yxj.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 19:25:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOp6jLa2xGcyg-rmE78FTpi11SbBq+EkWhXc+5na5QuebuFSBg@mail.gmail.com>
References: <CAOp6jLa2xGcyg-rmE78FTpi11SbBq+EkWhXc+5na5QuebuFSBg@mail.gmail.com>
Date: Fri, 12 Aug 2011 10:25:53 +0800
Message-ID: <CAJ-Vmont2OdEGFqBKOen8XW+fTvA2xBgVr1h9vSeOBcQrE_FxA@mail.gmail.com> (sfid-20110812_042558_674722_7036C655)
Subject: Re: [ath9k-devel] Packet loss regression with Atheros AR9280 adapter
From: Adrian Chadd <adrian@freebsd.org>
To: robert@ocallahan.org
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 August 2011 21:53, Robert O'Callahan <robert@ocallahan.org> wrote:
> Running Fedora 15's 2.6.40 kernel with compat-wireless (built from August 8
> tarball), I get persistent and quite severe packet loss with the AR9280 on
> my desktop machine. This started happening since I upgraded from Fedora 13
> to 15. Same box works fine running Windows 7, and other devices on the same
> network have no problems. The AP is in the same room as the AR9280, about
> three metres away. I have tried various versions of compat-wireless, passing
> nohwcrypt=1 to ath9k, and limiting the rate to 1Mb/s, all to no avail.
>
> How can I help debug this? Last 500 lines of dmesg attached.

Are you able to run an earlier version of compat-wireless, see if it
is a problem?



Adrian
