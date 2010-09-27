Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:48957 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758556Ab0I0BFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Sep 2010 21:05:19 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0231029515
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:05:17 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: Re: [PATCH] ath9k_htc: Fix TKIP disconnect failure with HTC drivers
Date: Mon, 27 Sep 2010 10:05:15 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1285331330-26105-1-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1285331330-26105-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201009271005.15434.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri September 24 2010 21:28:50 Rajkumar Manoharan wrote:
> The following commit removed splitmic. But forgot to add
> ATH_CRYPT_CAP_MIC_COMBINED flag for HTC drivers which causes
> TKIP to fail.
> 
> Author: Bruno Randolf <br1@einfach.org>
> Date:   Wed Sep 8 16:04:54 2010 +0900
> 
>     ath/ath9k: Replace common->splitmic with a flag
> 
>     Replace common->splitmic with ATH_CRYPT_CAP_MIC_COMBINED flag.
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>

sorry for that!

bruno
