Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:50077 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab0A1RgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 12:36:06 -0500
Message-ID: <4B61C907.4010408@am.sony.com>
Date: Thu, 28 Jan 2010 09:27:35 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
MIME-Version: 1.0
To: Hamish Guthrie <hamish.guthrie@sonycom.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"cbe-oss-dev@ozlabs.org" <cbe-oss-dev@ozlabs.org>
Subject: Re: [PATCH 2/2] ps3_gelic_wireless: fix directed ssid scan
References: <1264679650-14201-1-git-send-email-hamish.guthrie@sonycom.com> <1264679650-14201-3-git-send-email-hamish.guthrie@sonycom.com>
In-Reply-To: <1264679650-14201-3-git-send-email-hamish.guthrie@sonycom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2010 03:54 AM, Hamish Guthrie wrote:
> If the association worker requests a directed ssid scan and a bss list
> already exists, the directed scan is not done. This patch corrects this
> and cleans up a few typos and debug messages.
> 
> Signed-off-by: Hamish Guthrie <hamish.guthrie@sonycom.com>
> ---
>  drivers/net/ps3_gelic_wireless.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)

Looks good.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

