Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:24601 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZINJLA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 05:11:00 -0400
Received: by fg-out-1718.google.com with SMTP id 22so478349fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 02:11:03 -0700 (PDT)
Message-ID: <4AAE08A2.9080504@gmail.com>
Date: Mon, 14 Sep 2009 11:10:58 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/4] ath5k: define ath_common ops
References: <1252919221-13628-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252919221-13628-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2009 11:07 AM, Luis R. Rodriguez wrote:
> Only common ath read/write ops go through the common ops.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> Here's a respin of 3/4 based on Jiri's comments.

Thanks.

Acked-by: Jiri Slaby <jirislaby@gmail.com>
