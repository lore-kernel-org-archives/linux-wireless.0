Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:47341 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaFKPp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 11:45:29 -0400
Received: by mail-oa0-f41.google.com with SMTP id l6so3583261oag.14
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 08:45:29 -0700 (PDT)
Message-ID: <53987997.2040101@lwfinger.net> (sfid-20140611_174533_320392_E48CD71F)
Date: Wed, 11 Jun 2014 10:45:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Driver for Mediatek MT7630E
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In a recent E-mail interchange 
(http://marc.info/?l=linux-wireless&m=140238255916367&w=2), I was made aware 
that this device is not currently being handled by any driver in the kernel, but 
that there was a GitHub repo at https://github.com/anthonywong/mt7630. That code 
modifies rt2800pci to operate the MT7630E, but it is quite outdated.

As a followup, I found such a device at a reasonable price on E-bay, and ordered 
it. It should arrive next week. I also was able to find the firmware in an RPM 
for SUSE SLE11, and a license allowing redistribution. Before I start modifying 
rt2800pci for this new device, I want to be assured that this modification is 
not currently being done by anyone in the rt2x00 project. There is too much to 
be done to duplicate effort.

For interested readers, I have modified the GitHub code to compile using the 
current wireless-testing kernel source. If there is sufficient interest, I could 
set up a new GH repo for it as an interim measure with conditional code allowing 
it to build on recent kernels (3.5+).

Thanks,

Larry
