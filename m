Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63748 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3GSHCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 03:02:30 -0400
Message-ID: <51E8E482.30505@suse.cz> (sfid-20130719_090246_399369_325CCD6B)
Date: Fri, 19 Jul 2013 09:02:26 +0200
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: brcm80211-dev-list@broadcom.com
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: brcm80211: machine freezing hard with rfkill on
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

our users report [1] that their machines freeze hard when they have
rfkill turned on and try to run wpa_supplicant or enable network
otherwise. This is with BCM43225 over PCI chip.

Any ideas what that could be or how to fix this?

[1] https://bugzilla.novell.com/show_bug.cgi?id=787649

thanks,
-- 
js
suse labs
