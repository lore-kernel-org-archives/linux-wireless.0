Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:57430 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752186Ab0ENQRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 12:17:40 -0400
Received: from h135.188.123.208.ip.windstream.net ([208.123.188.135] helo=[206.223.20.39])
	by host200.hostmonster.com with esmtpa (Exim 4.69)
	(envelope-from <dhlii@dlasys.net>)
	id 1OCxZz-0006Wh-9P
	for linux-wireless@vger.kernel.org; Fri, 14 May 2010 10:17:39 -0600
Message-ID: <4BED77A2.7050105@dlasys.net>
Date: Fri, 14 May 2010 12:17:38 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compat-wireless
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

     I am working with the carl9170 driver.
     I have a working development environment based on wireless-testing.

     I am going to need to support carl9170 with older linux versions.
     I pullled the compat-wireless git tree and can not figure out how 
to build from it.
         Is there any step by step instructions to get from the raw git 
tree to being able to build against a specific kernel source ?

     I DL'd the compat-wireless tarball for 2.6.32. I was able to get 
that working against ubuntu lucid kernel sources.
     When I add the carl9170 driver I get a large collection of errors 
building it.
             While some of these appear to be very specific to this 
driver many seem specific to differences between 2.6.32 compat-wireless 
and wireless testing. I was hoping moving to the compat-wireless git 
tree would fix that, but I can not figure out how to build from it.

     In an altogether different project it would be useful use 
compat-wireless to support a newer wifi driver with a 2.6.27 kernel. 
That seems fairly standard. But I need to cross compile the kernel. As 
best as I can tell compat-wireless is setup  to work against your 
current running kernel. Are there any pointers for cross-compiling with 
compat-wireless, or for building against source other than that for the 
running kernel ?

Thanks





-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

