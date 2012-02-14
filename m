Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:60791 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759480Ab2BNHgs (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 14 Feb 2012 02:36:48 -0500
Received: by bkcjm19 with SMTP id jm19so5181041bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 23:36:40 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 14 Feb 2012 15:36:40 +0800
Message-ID: <CALx5=V8fwMpsicRyrSKk3nnZjfo8oMYbCxmrPFxDeps-5JSn+Q@mail.gmail.com> (sfid-20120214_083701_617883_3400FEBA)
Subject: ath9k LED behaviors.
From: Matt Chen <machen@suse.com>
To: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,

I am sorry if I asked this issue before or not.
I meet an issue in my laptop which is using the 168c:0032, driver is
ath9k.  I found if I press Fn+F12 to enable/disable the wifi, the LED
would take about 5 or 6 seconds to be ON or OFF. I found the in ath9k
would detect the GPIO status to change the rfkill status. and also
rfkill in ath9k is using polling way to monitor the status of GPIO
status. In other my machines with the same module and driver (ath9k),
press Fn+F12 would be easy to find out the LED is ON or OFF, would not
take too long. ( probably less than 1 second )
So is there any way to find out which driver has the right to change
the GPIO status ?
