Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp156.iad.emailsrvr.com ([207.97.245.156]:49663 "EHLO
	smtp156.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823AbXGEOIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2007 10:08:21 -0400
Message-ID: <468CFB00.9020302@gentoo.org>
Date: Thu, 05 Jul 2007 10:06:56 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
CC: linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	geoffrey.levand@am.sony.com
Subject: Re: [PATCH] zd1211rw: Add ID for Plannex GW-US54GXS
References: <20070705165600.D014.MOKUNO@sm.sony.co.jp>
In-Reply-To: <20070705165600.D014.MOKUNO@sm.sony.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Masakazu Mokuno wrote:
> This patch adds the ID for Plannex GW-US54GXS USB wireless adapter sold in 
> Japan.
> Since this device returns the regulatory region as 0x49,
> the patch 'Allow channels 1-11 for unrecognised regulatory domains' is
> required.

Thanks, added to my tree.

Daniel

