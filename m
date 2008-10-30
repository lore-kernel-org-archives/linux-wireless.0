Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:33091 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbYJ3QuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 12:50:18 -0400
Message-ID: <4909E5B8.5000508@lwfinger.net> (sfid-20081030_175024_941624_43A53A07)
Date: Thu, 30 Oct 2008 09:50:00 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: Re: [PATCH] p54: don't report known but unhandled EEPROM codes as
 unknown
References: <20081029213143.4497.77258.stgit@dv.roinet.com>
In-Reply-To: <20081029213143.4497.77258.stgit@dv.roinet.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  drivers/net/wireless/p54/p54common.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 

ACK - This patch cleans up my logs.

Larry

