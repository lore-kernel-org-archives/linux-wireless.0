Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56562 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaHKSvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 14:51:25 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so4732087wib.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2014 11:51:24 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: ipw2x00: ipw2200.c:  Cleaning up missing null-terminate in conjunction with strncpy 
Date: Mon, 11 Aug 2014 20:52:55 +0200
Message-Id: <1407783176-31297-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140811_205129_201577_DE03BBB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there any reason that can not simply use the variable ssid directly
in IPW_DEBUG_MERGE call instead of copying it to the escaped variable?

Rickard Strandqvist (1):
  net: wireless: ipw2x00: ipw2200.c:  Cleaning up missing null-terminate in conjunction with
    strncpy

 drivers/net/wireless/ipw2x00/ipw2200.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
1.7.10.4

