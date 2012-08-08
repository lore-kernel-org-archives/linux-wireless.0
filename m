Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8363 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab2HHUs0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 16:48:26 -0400
Date: Wed, 8 Aug 2012 16:48:13 -0400
From: Pavel Roskin <proski@gnu.org>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] ath9k: decrypt_error flag issue
Message-ID: <20120808164813.0011148e@mj> (sfid-20120808_224829_498304_7FA8A764)
In-Reply-To: <CAA2SeNLv9pE_3_-99Df_s0gF+56O6TFjfDfV-QuVxsOc6_Z5TQ@mail.gmail.com>
References: <CAA2SeNLv9pE_3_-99Df_s0gF+56O6TFjfDfV-QuVxsOc6_Z5TQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 8 Aug 2012 19:20:15 +0200
Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> wrote:

> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> ---

Please see Documentation/SubmittingPatches in Linux sources.  In
particular, you separated the description of the patch from its
contents.  Single patch doesn't need to be send as series.  The
description for the series is not a substitute for a description of
every patch.

Also, the subject should summarize the patch.  I know, it may be hard
to fit, but not impossible.

When exactly would you have the problem that decrypt_error is not
unset, but should be?  It's important that you show your assumptions so
that others can see if they are correct, in addition to checking the
code.  Other developers are more likely to check your patch if you
show understanding of the code you have changed.

> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -1780,7 +1780,6 @@

That's weird, recv.c is 1273 lines long in wireless-testing.git.

-- 
Regards,
Pavel Roskin
