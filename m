Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:54210 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZESVnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 17:43:40 -0400
Received: by gxk10 with SMTP id 10so129855gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 14:43:41 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 May 2009 22:43:41 +0100
Message-ID: <d1d209c50905191443v20cc897bo8629fbe0eb994df6@mail.gmail.com>
Subject: Ath9k Driver - AR928x - Bug
From: Harry H <bluestreek@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am using Ubuntu 8.10 and I cannot seem to make ath9k work. I have
used 9.04 and kernels from 2.6.27-7 to 2.6.30rc5. I have used compat
wireless from jan feb mar apr and may up to todays. I have reinstalled
approximately 20 times with no effect. I might add that it worked
sporadically using ubuntu 8.04 for a time and in 8.10 temporarily but
on upgrading broke again.

The problem is that I can see networks and scan fine yet when I
connect to a network my signal drops to 0% almost instantly. I think
now its better than it was a week ago when it dropped to 0% instantly
now it seems to wait for traffic then drop to 0%. If I now press
refresh and rescan I can see mostly all of the same networks but they
are all about from 0-5% signal strength.

If I now down wlan0 and up it again it will revert back to the usual
signal on all networks but on connection drop back to 0%. If there is
anything else I should do to give more information please contact me.

I am usually in the channel #linux-wireless and #madwifi.  I have done
my best to fix this by myself but I can see no alternative.

Regards,

[hR]
