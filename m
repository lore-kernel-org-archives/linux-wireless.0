Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:33994 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbYDXNJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 09:09:11 -0400
Received: by wa-out-1112.google.com with SMTP id m16so5393243waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2008 06:09:11 -0700 (PDT)
Message-ID: <1ba2fa240804240609m261e2d7dwee48bf721b63a137@mail.gmail.com> (sfid-20080424_150944_333515_FE7D26DB)
Date: Thu, 24 Apr 2008 16:09:10 +0300
From: "Tomas Winkler" <tomas.winkler@intel.com>
To: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [ANN] Support for Intel Wifi Link 5000 Family
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Zhu Yi" <yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would like to announce  support for Wifi Link 5000 Family
This includes
  WiFi 5300 AGN 3x3 MIMO
  WiFi 5100 AGN 1x2 MIMO

The HW will  be enabled as part of iwlwifi (iwl4965) driver.

Over next few weeks we will publish patches that merge our effort over
wireless-testing repository.

Thanks
Tomas
