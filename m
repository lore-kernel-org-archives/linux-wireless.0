Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:61904 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYKNEmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 23:42:24 -0500
Received: by wa-out-1112.google.com with SMTP id v27so604746wah.21
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 20:42:23 -0800 (PST)
Reply-To: <IskiMJ@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Dan Williams" <dcbw@redhat.com>
Subject: RE: hostap managed mode, blank ESSID
Date: Thu, 13 Nov 2008 21:42:14 -0700
Message-ID: <NGBBIAECGKIICNHKJGIPEEJCCIAA.IskiMJ@gmail.com> (sfid-20081114_054229_222122_0267F4FE)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
In-Reply-To: <1226613275.29010.1.camel@localhost.localdomain>
From: iskimj@gmail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan wrote:
>When the card reports a blank SSID, that means it simply hasn't
>associated to the AP.  Are you sure your WEP or WPA keys are correct?
>You might also try a higher firmware version;

Hmmm, still no luck. I flashed to firmware 1.7.4. I disabled encryption. I
even tried iwconfig wlan1 ap <wireless MAC address> All without much change.
The ESSID is still blank and I haven't been able to associate with the AP.

