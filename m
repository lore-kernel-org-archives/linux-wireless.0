Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:60354 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaE1SfX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 14:35:23 -0400
Received: by mail-vc0-f181.google.com with SMTP id hy4so9387679vcb.40
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2014 11:35:22 -0700 (PDT)
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 May 2014 11:35:02 -0700
Message-ID: <CALCETrU=8+tnptdfva4p27nA-5=E31DwXagoLqUxYcLtEKrB+w@mail.gmail.com> (sfid-20140528_203528_597730_8C0CE442)
Subject: compat-wireless-2014-05-22 breaks ath10k in an Archer C7 v2
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It dies with 'otp calibration failed: 2'.

Some older version of the driver seemed to work fine.

--Andy
