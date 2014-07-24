Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:43437 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759211AbaGXPZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 11:25:23 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so2984146wes.15
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 08:25:22 -0700 (PDT)
MIME-Version: 1.0
From: Jean-Marie Lemetayer <jeanmarie.lemetayer@gmail.com>
Date: Thu, 24 Jul 2014 17:25:02 +0200
Message-ID: <CAAdc0hyDepy7zn+1TQsjcZpkSkQrwFhbkPBJoH0vYKqbqkktAg@mail.gmail.com> (sfid-20140724_172526_590508_C7310A45)
Subject: How to get RSSI periodically
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am looking for a way to get the RSSI of the SELECTED network with
the wpa_supplicant (2.1). To update periodically the status connection
icon of my app.

I known that I can get it with the command: 'bss <bssid>' but it seems
that this information is updated only when perform a scan.

Have I miss something simpler than doing a background scan on the freq
of the SELECTED network ?

Regards,
Jean-Marie Lemetayer
