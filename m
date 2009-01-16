Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms13-1.Sony.CO.JP ([211.125.136.229]:45960 "EHLO
	ms13.sony.co.jp" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758376AbZAPJzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:55:09 -0500
Received: from ms6.sony.co.jp (ms6.Sony.CO.JP [211.125.136.204])
 by ms13.sony.co.jp (R8/Sony) with ESMTP id n0G8lgQX011903
 for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 17:47:42 +0900 (JST)
Date: Fri, 16 Jan 2009 17:45:51 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: jgarzik@pobox.com, linville@tuxdriver.com
Subject: [PATCH 0/2] PS3: gelic: convert to net_device_ops
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Geoff Levand <geoffrey.levand@am.sony.com>
Message-Id: <20090116173633.0B69.40F06B3A@sm.sony.co.jp> (sfid-20090116_105517_970158_27F93679)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset converts the gelic driver to net_device_ops

	#1	PS3: gelic: convert the ethernet part to net_device_ops
	#2	PS3: gelic: wireless: convert the wireless part to
	  	net_device_ops

regards

-- 
Masakazu Mokuno

