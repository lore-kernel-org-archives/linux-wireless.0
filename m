Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46419 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab2AKMtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 07:49:33 -0500
Subject: Re: [PATCH] NFC: Download TI NFC init script
From: Johannes Berg <johannes@sipsolutions.net>
To: ilanelias78@gmail.com
Cc: samuel@sortiz.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
In-Reply-To: <1326285768-3073-1-git-send-email-ilane@ti.com> (sfid-20120111_134051_269239_A8A55A8B)
References: <1326285768-3073-1-git-send-email-ilane@ti.com>
	 (sfid-20120111_134051_269239_A8A55A8B)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Jan 2012 13:49:19 +0100
Message-ID: <1326286159.3417.1.camel@jlt3.sipsolutions.net> (sfid-20120111_134936_842572_3398ECC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-01-11 at 14:42 +0200, ilanelias78@gmail.com wrote:

> @@ -47,6 +59,36 @@ struct nfcwilink_hdr {
>  	u16 len;
>  } __packed;

> +struct bts_file_hdr {
> +	u32 magic;

All this new stuff, but also the old stuff above, seems to be missing
endian annotations.

johannes

