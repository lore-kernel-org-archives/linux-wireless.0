Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37680 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab2KDMBq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2012 07:01:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TUytk-0003he-Oj
	for linux-wireless@vger.kernel.org; Sun, 04 Nov 2012 13:01:52 +0100
Received: from 85-211-194-217.dynamic.dsl.as9105.com ([85-211-194-217.dynamic.dsl.as9105.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2012 13:01:52 +0100
Received: from cliffhanger by 85-211-194-217.dynamic.dsl.as9105.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2012 13:01:52 +0100
To: linux-wireless@vger.kernel.org
From: Cliff McDiarmid <cliffhanger@gardener.com>
Subject: 8192su beta - trying to build
Date: Sun, 4 Nov 2012 12:01:33 +0000 (UTC)
Message-ID: <loom.20121104T125621-892@post.gmane.org> (sfid-20121104_130159_014253_D1D77DC7)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I'm trying to build this driver which I know is in beta.  I'm using a relatively
new kernel (3.6.2).  Do I need an older one perhaps, getting the following error?

/home/sources/wireless/8192su/rtl8192su-master/rtlwifi/core.c: In function
'rtl_op_tx':
/home/sources/wireless/8192su/rtl8192su-master/rtlwifi/core.c:168:50: error:
dereferencing pointer to incomplete type
/home/sources/wireless/8192su/rtl8192su-master/rtlwifi/core.c:169:44: error:
dereferencing pointer to incomplete type
/home/sources/wireless/8192su/rtl8192su-master/rtlwifi/core.c: In function
'rtl_op_set_key':
/home/sources/wireless/8192su/rtl8192su-master/rtlwifi/core.c:1011:17: error:
'IEEE80211_KEY_FLAG_SW_MGMT_TX' undeclared (first use in this function)
/home/sources/wireless/8192su/rtl8192su-master/rtlwifi/core.c:1011:17: note:
each undeclared identifier is reported only once for each function it appears in
/home/sources/wireless/8192su/rtl8192su-master/rtlwifi/core.c: At top level:
/home/sources/wireless/8192su/rtl8192su-master/rtlwifi/core.c:1196:2: warning:
initialization from incompatible pointer type


thanks for any advice

regards

Cliff

