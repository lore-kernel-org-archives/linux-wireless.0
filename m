Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1CPWhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 18:37:52 -0400
Received: by iyb26 with SMTP id 26so2175328iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 15:37:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1299735343-915-2-git-send-email-vnatarajan@atheros.com>
References: <1299735343-915-1-git-send-email-vnatarajan@atheros.com> <1299735343-915-2-git-send-email-vnatarajan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 16 Mar 2011 15:37:32 -0700
Message-ID: <AANLkTinQBKT_G1=3NvORTkTaFS+jRP79cegVqZL6LMbw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ath9k_hw: Fix PLL initialization for AR9485.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 9, 2011 at 9:35 PM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
> Increase the delay to make sure the initialization of pll
> passes.
>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Was this a stable fix? If so why?

  Luis
