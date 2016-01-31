Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757218AbcAaOer (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 09:34:47 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8723au: Fixes unnecessary return warning
References: <20160130055747.GA16656@Karyakshetra>
Date: Sun, 31 Jan 2016 09:34:46 -0500
In-Reply-To: <20160130055747.GA16656@Karyakshetra> (Bhaktipriya Shridhar's
	message of "Sat, 30 Jan 2016 11:27:47 +0530")
Message-ID: <wrfj7fip24xl.fsf@redhat.com> (sfid-20160131_153504_883638_00D3E026)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bhaktipriya Shridhar <bhaktipriya96@gmail.com> writes:
> This patch fixes checkpatch.pl warning in rtw_mlme_ext.c file.
> WARNING: void function return statements are not generally useful
>
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
> ---
>  Changes in v2:
>    - Removed the unnecessary blank lines.
>  drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 20 --------------------
>  1 file changed, 20 deletions(-)

Harmless, albeit pointless, so fine with me.

Jes
