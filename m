Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:39310 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab1ENXw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 19:52:59 -0400
Received: from 173.221.84.2.nw.nuvox.net ([173.221.84.2] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1QLNqC-0001YF-EO
	for linux-wireless@vger.kernel.org; Sat, 14 May 2011 19:01:44 -0400
Date: Sat, 14 May 2011 19:01:38 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
Subject: useless references to CONFIG_ATHEROS_AR71XX
Message-ID: <alpine.DEB.2.00.1105141900060.13248@localhost6.localdomain6> (sfid-20110515_015310_351984_8AD64C3C)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


  there are a couple tests/references in the kernel source tree to the
Kconfig variable CONFIG_ATHEROS_AR71XX that is not defined in any
Kconfig file.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
