Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbaGMHZx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 03:25:53 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Raphael Silva <rapphil@gmail.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] rtl8723au: Corrections in the coding style
References: <1405215302-9982-1-git-send-email-rapphil@gmail.com>
Date: Sun, 13 Jul 2014 09:25:41 +0200
In-Reply-To: <1405215302-9982-1-git-send-email-rapphil@gmail.com> (Raphael
	Silva's message of "Sat, 12 Jul 2014 22:35:02 -0300")
Message-ID: <wrfj38e5yb2i.fsf@redhat.com> (sfid-20140713_092558_957055_E1B6EAF8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raphael Silva <rapphil@gmail.com> writes:
> Some corrections were made to the code in order to conform to the
> Kernel Coding Style.
> ---
>  drivers/staging/rtl8723au/core/rtw_sta_mgt.c | 42 ++++++++++++++++++----------
>  1 file changed, 27 insertions(+), 15 deletions(-)

Raphael,

Thank you for the patch, however we cannot accept it without the
required Signed-off-by line.

Please see Documentation/SubmittingPatches for details.

Thanks,
Jes
