Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbbIUGxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 02:53:00 -0400
Date: Sun, 20 Sep 2015 23:52:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 11/18] staging: wilc1000: rename
 WILC_WFI_set_cqm_rssi_config
Message-ID: <20150921065258.GA26714@kroah.com> (sfid-20150921_085304_057917_AC4E598E)
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
 <1442731885-4344-11-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442731885-4344-11-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 20, 2015 at 03:51:18PM +0900, Chaehyun Lim wrote:
> This patch replaces WILC_WFI_set_cqm_rssi_config with
> set_cqm_rssi_config to avoid CamelCase.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Doesn't apply as I didn't take patch 10 :(
