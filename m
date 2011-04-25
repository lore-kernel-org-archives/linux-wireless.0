Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab1DYRwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:52:44 -0400
Date: Mon, 25 Apr 2011 12:52:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/18] rtlwifi: rtl8192ce: rtl8192cu: Fix bugs, sparse
 warnings, and prepare for rtl8192se and rtl8192de
Message-ID: <4db5b4e7.2uRZK4EmgZUmqK8D%Larry.Finger@lwfinger.net> (sfid-20110425_195248_557079_48718A41)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series modifies drivers rtlwifi, rtl8192c-common, rtl8192ce and
rtl8192cu for the following reasons:

* Fix some bugs including, but not limited to, incorrect rate shown in iwconfig,
  and the addition of dummy reads to flush writes to the hardware
* Add Bluetooth coexistence code
* Modify rtlwifi for addition of drivers for RTL8192SE and RTL8192DE. One
  necessary change is to allow the selection of which PCI BAR to use.
* Modify rtl8192c-common, rtl8192ce and rtl8192cu for changes in rtlwifi
* Fix sparse warnings

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This material is for 2.6.40. There are bug fixes, but they are not
localized for submission as a separate patch for 2.6.39 and stable,
thus they will need to wait. The material will be needed for my next
patch bomb containing the rtl8192se driver.

Thanks,

Larry

