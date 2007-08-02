Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.231]:26147 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXHBHpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 03:45:16 -0400
Received: by hu-out-0506.google.com with SMTP id 19so298894hue
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2007 00:45:15 -0700 (PDT)
Message-ID: <46B18B77.5020802@gmail.com>
Date: Thu, 02 Aug 2007 09:44:55 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: chaning mode only when interface down?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I noticed that I have to do ifdown wlan0 before I can change the mode 
with iwconfig.
When I do it while the interface is up I get a error that the device is 
busy.
It seems to happen with ad-hoc, master and back from them to managed.
Is this a bug in the iwlwifi driver or in mac80211 ?
Because of this NM can't create ad-hoc networks because it does it while 
the device is up.
Any ideas?

