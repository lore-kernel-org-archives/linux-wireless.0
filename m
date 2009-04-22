Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c.6b.1343.static.theplanet.com ([67.19.107.12]:47083 "EHLO
	mail.bitnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbZDVKCb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 06:02:31 -0400
Received: from [91.87.219.137] (unknown [91.87.219.137])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.bitnet.be (Postfix) with ESMTP id 08AB7298280
	for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 05:02:29 -0500 (CDT)
Message-ID: <49EEEB4D.1090104@bitnet.be> (sfid-20090422_120235_353092_B8E19A8F)
Date: Wed, 22 Apr 2009 12:02:53 +0200
From: Hans Maes <Hans@bitnet.be>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: regulatory db: MAX EIRP for BE wrong?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

According to 
http://wireless.kernel.org/en/developers/Regulatory/Database?alpha2=BE 
the max EIRP for BE (Belgium) on the 5490-5710 Mhz band is 27dBm (500mW)

I was under the impression that it is actually 30dBm (1W) on that band, 
according to BIPT (Belgian Institute for Post and Telecommunications) 
regulations.

I've been trying to find a link to an official BIPT document but can't 
find one right now.
However, scroll to "Table 3" in this cisco document 
http://www.cisco.com/en/US/docs/routers/access/wireless/rcsi/radiocom.html 
to see that Cisco uses 30dBm (1000mW) in their products.

Would it be possible to update the reg db ?

If you need extra information, let me know.

Thanks!

Regards,

Hans
