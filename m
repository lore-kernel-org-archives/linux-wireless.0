Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab3AGLSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 06:18:05 -0500
Date: Mon, 7 Jan 2013 12:17:53 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wireless/iwlegacy: use strlcpy instead of
 strncpy
Message-ID: <20130107111752.GD6931@redhat.com> (sfid-20130107_121810_186482_46FA77EA)
References: <50EA5246.8060206@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50EA5246.8060206@asianux.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 07, 2013 at 12:42:46PM +0800, Chen Gang wrote:
> 
>   The fields must be null-terminated, or simple_strtoul will cause issue.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

ACK

