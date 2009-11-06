Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:50131 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbZKFH0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 02:26:11 -0500
Received: from [192.168.10.9] ([192.168.10.9])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.14.3/8.14.3) with ESMTP id nA67QDud019469
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2009 00:26:16 -0700
Message-ID: <4AF3CFA8.7010808@redfish-solutions.com>
Date: Thu, 05 Nov 2009 23:26:32 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ipw2100 still broken when compiled against 2.6.27.29
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anyone else noticed that ipw2100 has been broken for several days when 
compiled against 2.6.27.29?

  CC [M]  /home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.o
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c: In function 'ipw2100_alloc_device':
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:6063: error: 'struct iw_public_data' has no member named 'ieee80211'
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c: At top level:
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:8328: error: unknown field 'num_private' specified in initializer
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:8328: warning: initialization makes pointer from integer without a cast
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:8329: error: unknown field 'num_private_args' specified in initializer
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:8329: warning: excess elements in struct initializer
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:8329: warning: (near initialization for 'ipw2100_wx_handler_def')
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:8330: error: unknown field 'private' specified in initializer
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:8330: warning: excess elements in struct initializer
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:8330: warning: (near initialization for 'ipw2100_wx_handler_def')
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:8331: error: unknown field 'private_args' specified in initializer
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:8331: warning: excess elements in struct initializer
/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.c:8331: warning: (near initialization for 'ipw2100_wx_handler_def')
make[5]: *** [/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00/ipw2100.o] Error 1
make[4]: *** [/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless/ipw2x00] Error 2
make[3]: *** [/home/philipp/alix/build_i586/compat-wireless-2009-11-04/drivers/net/wireless] Error 2
make[2]: *** [_module_/home/philipp/alix/build_i586/compat-wireless-2009-11-04] Error 2



