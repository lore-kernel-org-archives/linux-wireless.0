Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52786 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaJJK5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 06:57:30 -0400
Received: by mail-wi0-f182.google.com with SMTP id n3so1645256wiv.9
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2014 03:57:29 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: assoc clean ups 2014-10-10
Date: Fri, 10 Oct 2014 12:46:14 +0200
Message-Id: <1412937977-5859-1-git-send-email-michal.kazior@tieto.com> (sfid-20141010_125733_695724_86761D06)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a bunch of assoc-related clean ups.


Michal Kazior (3):
  ath10k: clean up assoc code
  ath10k: skip some commands on reassoc
  ath10k: clean up sta auth/assoc code

 drivers/net/wireless/ath/ath10k/mac.c | 267 +++++++++++++++-------------------
 1 file changed, 117 insertions(+), 150 deletions(-)

-- 
1.8.5.3

