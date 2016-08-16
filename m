Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.amrita.ac.in ([103.10.24.206]:58612 "EHLO
	mailsecurity.amrita.ac.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbcHPMZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 08:25:04 -0400
Received: from durga.amrita.ac.in ([10.0.0.3])
	by mailsecurity.amrita.ac.in  with ESMTP id u7GC9ngO011652-u7GC9ngQ011652
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2016 17:39:49 +0530
Received: from durga.amrita.ac.in (localhost [127.0.0.1])
	by durga.amrita.ac.in (Postfix) with ESMTPS id 69BA638C57D2
	for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2016 17:39:38 +0530 (IST)
Received: from localhost (localhost [127.0.0.1])
	by durga.amrita.ac.in (Postfix) with ESMTP id 5BFF438C57AD
	for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2016 17:39:38 +0530 (IST)
Received: from durga.amrita.ac.in ([127.0.0.1])
	by localhost (durga.amrita.ac.in [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id THkR4tBOZ8iY for <linux-wireless@vger.kernel.org>;
	Tue, 16 Aug 2016 17:39:38 +0530 (IST)
Received: from durga.amrita.ac.in (durga.amrita.ac.in [10.0.0.3])
	by durga.amrita.ac.in (Postfix) with ESMTP id 4861038C57A7
	for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2016 17:39:38 +0530 (IST)
Date: Tue, 16 Aug 2016 17:39:38 +0530 (IST)
From: Sambhu R <rsambhu@am.amrita.edu>
To: linux-wireless@vger.kernel.org
Message-ID: <1902731527.3857839.1471349378230.JavaMail.zimbra@am.amrita.edu> (sfid-20160816_142510_392928_DBE814E0)
Subject: regarding RTL8188SU
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was following your--> https://github.com/chunkeey/rtl8192su but i couldn't install. When i execute ./install.sh i'm getting the following error.

make[1]: Entering directory '/usr/src/linux-headers-3.4.112-sun8i'
Makefile:568: /usr/src/linux-headers-3.4.112-sun8i/arch/armv7l/Makefile: No such file or directory
make[1]: *** No rule to make target '/usr/src/linux-headers-3.4.112-sun8i/arch/armv7l/Makefile'.  Stop.
make[1]: Leaving directory '/usr/src/linux-headers-3.4.112-sun8i'
Makefile:220: recipe for target 'modules' failed
make: *** [modules] Error 2
##################################################
Compile make driver error: 2
Please check error Mesg
##################################################

please help..

OS details:
Distributor ID:	Debian
Description:	Debian GNU/Linux 8.5 (jessie)
Release:	8.5
Codename:	jessie
Linux orangePi1 3.4.112-sun8i #8 SMP PREEMPT  armv7l GNU/Linux








-- Disclaimer:     The information transmitted in this email, including attachments, is intended only for the person(s) or entity to which it is addressed and may contain confidential and/or privileged material. Any review, retransmission, dissemination or other use of, or taking of any action in reliance upon this information by persons or entities other than the intended recipient is prohibited.Any views expressed in any message are those of the individual sender and may not necessarily reflect the views of Amrita University. If you received this in error, please contact the sender and destroy any copies of this information. 
