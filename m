Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60629 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab2HOKMr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2012 06:12:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1T1aah-0001Ac-9q
	for linux-wireless@vger.kernel.org; Wed, 15 Aug 2012 12:12:43 +0200
Received: from linuxconsulting.iasi.rdsnet.ro ([86.124.39.167])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2012 12:12:43 +0200
Received: from npavel by linuxconsulting.iasi.rdsnet.ro with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2012 12:12:43 +0200
To: linux-wireless@vger.kernel.org
From: Nicu Pavel <npavel@mini-box.com>
Subject: rtl8192cu stuck as connected although the AP is down.
Date: Wed, 15 Aug 2012 10:12:32 +0000 (UTC)
Message-ID: <loom.20120815T115319-610@post.gmane.org> (sfid-20120815_121251_571814_B41E94DE)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

rtl8192cu driver doesn't seem to react when AP that is connected to is 
closed/shutdown.
I have this behavior with 2 different rtl8192cu devices (tplink and edup vendors)
With another adapter based on rtl8187 the adapter immediately detects that AP is 
no longer on and wpa_supplicant disconnects from AP.

With rtl8192cu wpa_supplicant still thinks that is connected to AP.

Any suggestion where to start looking ?

Thanks,
Nicu Pavel



