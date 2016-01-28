Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e06smtp05.uk.ibm.com ([195.75.94.101]:37606 "EHLO
	e06smtp05.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966476AbcA1P2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 10:28:02 -0500
Received: from localhost
	by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
	Thu, 28 Jan 2016 15:27:58 -0000
Date: Thu, 28 Jan 2016 16:27:51 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	Joe Perches <joe@perches.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Steve French <sfrench@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] param: convert some "on"/"off" users to strtobool
Message-ID: <20160128152751.GB3926@osiris> (sfid-20160128_162809_776741_57FBC32A)
References: <1453990627-19164-1-git-send-email-keescook@chromium.org>
 <1453990627-19164-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453990627-19164-4-git-send-email-keescook@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 28, 2016 at 06:17:07AM -0800, Kees Cook wrote:
> This changes several users of manual "on"/"off" parsing to use strtobool.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: x86@kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-s390@vger.kernel.org
> ---
>  arch/powerpc/kernel/rtasd.c                  | 10 +++-------
>  arch/powerpc/platforms/pseries/hotplug-cpu.c | 11 +++--------
>  arch/s390/kernel/time.c                      |  8 ++------
>  arch/s390/kernel/topology.c                  |  8 +++-----
>  arch/x86/kernel/aperture_64.c                | 13 +++----------
>  include/linux/tick.h                         |  2 +-
>  kernel/time/hrtimer.c                        | 11 +++--------
>  kernel/time/tick-sched.c                     | 11 +++--------
>  8 files changed, 21 insertions(+), 53 deletions(-)

For the s390 bits:

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

