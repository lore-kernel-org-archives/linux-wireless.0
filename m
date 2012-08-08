Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60411 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030573Ab2HHRTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 13:19:05 -0400
Received: by obbuo13 with SMTP id uo13so1391155obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 10:19:03 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Aug 2012 19:19:03 +0200
Message-ID: <CAA2SeNLSJNohf5vPwDz_QAZguYS-Eu=24b5nerXeWF49w2W4Pw@mail.gmail.com> (sfid-20120808_191920_434676_F3A3DA42)
Subject: [PATCH 0/1] ath9k: decrypt_error flag issue
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com, John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed an issue in decrypt_error flag management of ath_rx_tasklet.
In particular, when the hw reports a decryption error this flag is not
reset to false.

Regards

Lorenzo
