Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbbI0CZi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2015 22:25:38 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Pinkesh Badjatiya <pinkeshbadjatiya@gmail.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	gdonald@gmail.com, luca@lucaceresoli.net,
	rickard_strandqvist@spectrumdigital.se, carlos@cgarcia.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removed extra spaces, and error from checkpatch.pl
References: <20150927001415.GA34976@ubuntu>
Date: Sat, 26 Sep 2015 22:25:34 -0400
In-Reply-To: <20150927001415.GA34976@ubuntu> (Pinkesh Badjatiya's message of
	"Sun, 27 Sep 2015 05:44:16 +0530")
Message-ID: <wrfjio6wr42p.fsf@redhat.com> (sfid-20150927_042555_042910_A36FBAD0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pinkesh Badjatiya <pinkeshbadjatiya@gmail.com> writes:
> Removed trailing spaces.
> Fixed some errors from checkpatch.pl verification.
> No changes made to actual functional code.
>
> Signed-off-by: Pinkesh Badjatiya <pinkeshbadjatiya@gmail.com>
> ---
>  drivers/staging/rtl8723au/include/rtw_cmd.h | 162 ++++++++++++++--------------
>  1 file changed, 80 insertions(+), 82 deletions(-)

Please read the guidelines for how to post a patch for staging. The
subject line needs to have the correct prefixes for it to be considered.

Jes
