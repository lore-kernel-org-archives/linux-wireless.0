Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34867 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbaIIJ5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 05:57:04 -0400
Received: from mfilter18-d.gandi.net (mfilter18-d.gandi.net [217.70.178.146])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 5CC41A80B4
	for <linux-wireless@vger.kernel.org>; Tue,  9 Sep 2014 11:56:59 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter18-d.gandi.net (mfilter18-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id BCFkv37ch7Cv for <linux-wireless@vger.kernel.org>;
	Tue,  9 Sep 2014 11:56:58 +0200 (CEST)
Received: from nuvo (mon69-7-83-155-44-161.fbx.proxad.net [83.155.44.161])
	(Authenticated sender: hadess@hadess.net)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id A93CBA80AF
	for <linux-wireless@vger.kernel.org>; Tue,  9 Sep 2014 11:56:57 +0200 (CEST)
Message-ID: <1410256608.4077.7.camel@hadess.net> (sfid-20140909_115708_323926_84318F9B)
Subject: Realtek GPIO chipset, for Baytrail?
From: Bastien Nocera <hadess@hadess.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 09 Sep 2014 11:56:48 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

I have a tablet that seems to be using Realtek chips to do wireless
communications (hopefully, this time I won't be wrong[1]).

The device, under the gpio class in /sys, shows with a modalias of
"acpi:OBDA8723:" (that's on "O", not "0"). This seems to correspond to a
Realtek chipset (Larry tells me it matches the PCI ID of 0bda:8723 for
the RTL8723AE chipset).

It shows up under:
/sys/devices/platform/80860F0A:00/subsystem/devices

Does anyone have details on how this chipset is actually hooked up? Can
a portion of the existing RTL8723AE driver code be reused?

Cheers

[1]:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/127591/focus=127703

