Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:48444 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbaJUOGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 10:06:44 -0400
Received: by mail-la0-f42.google.com with SMTP id gf13so1238600lab.15
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 07:06:42 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: minor htt tracing fix
Date: Tue, 21 Oct 2014 15:54:58 +0200
Message-Id: <1413899700-10717-1-git-send-email-michal.kazior@tieto.com> (sfid-20141021_160647_712298_49009E30)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've just noticed that rx_desc tracing is somewhat
wrong. This attempts to fix it and since the trace
function prototype changes I re-use some tracing
code as well.


Michal Kazior (2):
  ath10k: remove tsf argument from rx_desc tracing
  ath10k: re-use trace class

 drivers/net/wireless/ath/ath10k/htt_rx.c |  4 +---
 drivers/net/wireless/ath/ath10k/trace.h  | 35 +++++---------------------------
 2 files changed, 6 insertions(+), 33 deletions(-)

-- 
1.8.5.3

