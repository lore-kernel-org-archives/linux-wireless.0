Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:21781 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZHXQl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 12:41:29 -0400
Received: by rv-out-0506.google.com with SMTP id f6so755423rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2009 09:41:31 -0700 (PDT)
Message-ID: <4A92C269.9010301@lwfinger.net>
Date: Mon, 24 Aug 2009 11:40:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: [Fwd: [Bug 13725] p54 gets a "tx refused but queue active" WARNING
 from mac80211]
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian and Johannes,

A dongle running p54usb gets a "tx refused but queue active" WARNING
when used as an AP using hostapd and running 2.6.31-rc6 from Linus's
tree, even with my patch that fixed this problem in STA mode.
Christian, have you tested this configuration? Johannes - any thoughts?

I'm trying to reproduce the problem.

Larry

======================================================================

-------- Original Message --------
Subject: [Bug 13725] p54 gets a "tx refused but queue active" WARNING
from mac80211
Date: Mon, 24 Aug 2009 15:22:34 GMT
From: bugzilla-daemon@bugzilla.kernel.org
To: Larry.Finger@lwfinger.net
References: <bug-13725-734@http.bugzilla.kernel.org/>

http://bugzilla.kernel.org/show_bug.cgi?id=13725





--- Comment #3 from cortez8591@gmail.com  2009-08-24 15:22:33 ---
I'm using p54usb dongle with hostapd to share my Internet connection.
After
client connects with station and start browsing/downloading it takes
0.5 - 1min
and suddenly network sharing stops working. The only error message
comes from
dmesg and it is the error mentioned before. System load was from 0.10
to 0.30
max.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You reported the bug.

