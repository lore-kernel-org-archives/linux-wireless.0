Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:53585 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356AbZJNVxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 17:53:15 -0400
Received: from [192.168.10.7] (builder.redfish-solutions.com [192.168.10.7])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.3/8.14.3) with ESMTP id n9ELqZTD026654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 15:52:39 -0600
Message-ID: <4AD64823.9020906@redfish-solutions.com>
Date: Wed, 14 Oct 2009 14:52:35 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Issues building compat-wireless-2009-10-13
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generated a snapshot at midnight, Pacific.

Tried to build it against 2.6.27.29 a little while ago.  Seeing:

  CC [M]  /home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.o
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c: In function 'ipw2100_alloc_device':
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:6063: error: 'struct iw_public_data' has no member named 'ieee80211'
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c: At top level:
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:8325: error: unknown field 'num_private' specified in initializer
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:8325: warning: initialization makes pointer from integer without a cast
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:8326: error: unknown field 'num_private_args' specified in initializer
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:8326: warning: excess elements in struct initializer
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:8326: warning: (near initialization for 'ipw2100_wx_handler_def')
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:8327: error: unknown field 'private' specified in initializer
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:8327: warning: excess elements in struct initializer
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:8327: warning: (near initialization for 'ipw2100_wx_handler_def')
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:8328: error: unknown field 'private_args' specified in initializer
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:8328: warning: excess elements in struct initializer
/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.c:8328: warning: (near initialization for 'ipw2100_wx_handler_def')
make[5]: *** [/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00/ipw2100.o] Error 1
make[4]: *** [/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless/ipw2x00] Error 2
make[3]: *** [/home/philipp/alix/build_i586/compat-wireless-2009-10-13/drivers/net/wireless] Error 2
make[2]: *** [_module_/home/philipp/alix/build_i586/compat-wireless-2009-10-13] Error 2
make[2]: Leaving directory `/home/philipp/alix/build_i586/linux-2.6.27.29-astlinux'
make[1]: *** [modules] Error 2
make[1]: Leaving directory `/home/philipp/alix/build_i586/compat-wireless-2009-10-13'
make: *** [/home/philipp/alix/build_i586/compat-wireless-2009-10-13/net/wireless/lib80211.ko] Error 2



Is this a known issue?

Thanks,

-Philip


