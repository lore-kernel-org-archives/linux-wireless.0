Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33086 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1KGDa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Nov 2011 22:30:29 -0500
Received: by vcbf1 with SMTP id f1so1773180vcb.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Nov 2011 19:30:29 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 6 Nov 2011 21:30:29 -0600
Message-ID: <CAJsNL7n+tZ2RrH9Tb_ccwUCPNq+7pVHp_-mGV_dT1JxAhQrJ1Q@mail.gmail.com> (sfid-20111107_043032_990476_E07D1A7A)
Subject: Random disconnect after association is complete
From: alfred steele <alfred.jaquez@gmail.com>
To: hostap@lists.shmoo.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

wpa_supplicant v 0.6.8: There is a suddent disconnect apperaing in the
control event interface immediately after association and then the
Disconnet-remove keys" goes on for about one minute before stopping.
After association, there are  a number of "Key negotiation completed"
events pop up in  around 20 seconds followed by
"CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys" and this
pattern repeats itslef

Is this about some specific configuration in wpa supplicant, may be
related to ap_scan=2, i see a bunch of braodcast probe requests from
the chip when this happens.

Thanks in Advance!
Alfred
