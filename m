Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from civicrm.laptop.org ([18.85.44.157]:34527 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725735AbeHXFPr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 01:15:47 -0400
Date: Fri, 24 Aug 2018 11:36:45 +1000
From: James Cameron <quozl@laptop.org>
To: linux-wireless@vger.kernel.org,
        Mylene JOSSERAND <mylene.josserand@free-electrons.com>,
        Stefan Pappalardo <stefan.pappalardo@gmx.de>,
        Carlo Caione <carlo@endlessm.com>
Cc: Jes.Sorensen@gmail.com
Subject: rtl8723bu: low signal, fails to associate
Message-ID: <20180824013645.GB761@us.netrek.org> (sfid-20180824_034329_899494_5A12491C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

G'day Carlo, Mylene, and James,

Thanks for your earlier reports about RTL8723bu.  Have you any more
recent experiences you might share?

I'm evaluating a sample laptop which worked fine with Windows 10, but
not very well with Ubuntu 18.04, and kernel v4.15 or kernel v4.18.4.

The laptop is by Hena, model NT16-PRO-C-E, with a wireless device on
internal USB (0x0bda:0xb720) which loads rtl8xxxu, identifying as
RTL8723BU.

http://dev.laptop.org/~quozl/z/1ft0qv.txt (dmesg)

Symptoms are low RSSI on scan, very short range, and often a failure
to associate over a distance of two metres in a radio quiet location.

Symptoms began after first power off, which suggests that device
registers programmed by the previous operating system Windows 10 had
not been reset by reboot into the Ubuntu 18.04 installer.  The device
worked fine in Ubuntu 18.04 before the first power off.

Jes, let me know if there is anything I can do to help.

-- 
James Cameron
http://quozl.netrek.org/
