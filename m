Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50405 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbZLWIPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 03:15:53 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so6063598ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 00:15:52 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 2/5] rt2x00: Fix checks for rt2800 SOC support.
Date: Wed, 23 Dec 2009 09:15:50 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1261523005-5856-1-git-send-email-gwingerde@gmail.com> <1261523005-5856-2-git-send-email-gwingerde@gmail.com> <1261523005-5856-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1261523005-5856-3-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912230915.50975.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 December 2009, Gertjan van Wingerde wrote:
> Fix checking for SOC support in rt2800pci. The wrong config (an unexisting
> one) was checked.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)



