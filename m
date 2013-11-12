Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:48601 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3KLG2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 01:28:42 -0500
Received: by mail-wg0-f43.google.com with SMTP id n12so2589790wgh.34
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 22:28:41 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 12 Nov 2013 11:58:41 +0530
Message-ID: <CADNhdGHGnHDYdum79cY89kV4LtpiGugMc84Mc_4bNmCuOWrn5g@mail.gmail.com> (sfid-20131112_072846_005851_E269554C)
Subject: [mac80211] hooking all 802.11 packets to user space without conversion
From: shankar swaminathan <shankswa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I would like to know if 802.11 packets could be hooked from the mac80211
module to the user space.

Basically, I run a module that needs the 802.11 pkts without converting
them to 802.3.

I am able to register for MLME pkts but not sure whether I can register for
data pkts and get them to user space.



Please clarify.

Would be very helpful if you could get back ASAP.



thanks and regards,

-shankar
