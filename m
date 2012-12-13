Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:48602 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753376Ab2LMNTV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 08:19:21 -0500
Message-ID: <50C9D5D6.3060808@posedge.com> (sfid-20121213_141925_365311_C894459C)
Date: Thu, 13 Dec 2012 18:49:18 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [Query] Operation Mode Change on the Fly (AP-STA/STA-AP)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While trying to run hostapd in ubuntu i am seeing a error with regards "an operation already in progress" while registering mgmt_frame (208-action).
After some debugging found that the same action frame is registered by the STA (wpa_supplicant service was running by default) causing the AP mode to fail?

Is this expected behavior? (or) in order to support on the fly mode change, do we need purge the old state when starting a new mode and continue.
For Eg. in case of AP mode from hostapd, do we need to purge all entries registered by STA (from wpa_supplicant)?

For now disabled the wpa_supplicant service, but curious to know the design here.

Regards,
Chaitanya T K.
