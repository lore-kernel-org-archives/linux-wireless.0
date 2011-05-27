Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab1E0UGd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 16:06:33 -0400
Subject: please ignore advertise interface combinations patches in iwlwifi
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 12:38:51 -0700
Message-ID: <1306525131.14995.339.camel@wwguy-huron> (sfid-20110527_220637_219068_50AB9649)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please ignore the following 2 patches from the patch set I send you
earlier today

0007:iwlagn: advertise interface combinations
0010:iwlagn: don't advertise interface combinations on device not
support dualmode

those two patches will cause issue when P2P is not enable for iwlwifi
driver

sorry for the trouble

Thanks
Wey

