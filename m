Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:5268 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYG3HBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 03:01:10 -0400
Received: by ug-out-1314.google.com with SMTP id h2so225086ugf.16
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 00:01:08 -0700 (PDT)
Message-ID: <a7f8874a0807300001g55b479d0vc186752c0f2f2c3c@mail.gmail.com> (sfid-20080730_090114_692902_D68A9F50)
Date: Wed, 30 Jul 2008 00:01:08 -0700
From: "Hans Henry von Tresckow" <hvontres@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [BUG] wireless-compat breaks cdc_subset
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since wireless compat installs a new version of usb_ether and releated
modules, loading the cdc_subset module generates the following errors:

 6458.578311] cdc_subset: disagrees about version of symbol usbnet_suspend
[ 6458.578319] cdc_subset: Unknown symbol usbnet_suspend
[ 6458.578388] cdc_subset: disagrees about version of symbol usbnet_disconnect
[ 6458.578391] cdc_subset: Unknown symbol usbnet_disconnect
[ 6458.578417] cdc_subset: disagrees about version of symbol usbnet_probe
[ 6458.578419] cdc_subset: Unknown symbol usbnet_probe
[ 6458.578445] cdc_subset: disagrees about version of symbol usbnet_resume
[ 6458.578446] cdc_subset: Unknown symbol usbnet_resume


Please considder adding cdc_subset to wireless compat as well. Thank
you very much,
-- 
Henry von Tresckow (hvontres)
