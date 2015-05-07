Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.inescn.pt ([192.35.246.20]:52894 "EHLO trubo.inescn.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbbEGK53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 06:57:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by trubo.inescn.pt (8.13.8/8.14.3/8) with ESMTP id t47ApEo7026230
	for <linux-wireless@vger.kernel.org>; Thu, 7 May 2015 11:51:14 +0100
Received: from trubo.inescn.pt ([127.0.0.1])
	by localhost (trubo.inescn.pt [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id qoKr1SHPGS+3 for <linux-wireless@vger.kernel.org>;
	Thu,  7 May 2015 11:51:10 +0100 (WEST)
Received: from grover.inescn.pt (grover.inescn.pt [194.117.24.20])
	by trubo.inescn.pt (8.13.8/8.14.4/3) with ESMTP id t47Ap9Fr026169
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 7 May 2015 11:51:09 +0100
Received: from grover.inescn.pt (localhost.localdomain [127.0.0.1])
	by grover.inescn.pt (8.13.8/8.13.8/8) with ESMTP id t47Ap98c026404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 7 May 2015 11:51:09 +0100
Received: (from apache@localhost)
	by grover.inescn.pt (8.13.8/8.13.8/Submit) id t47Ap9nw026400
	for linux-wireless@vger.kernel.org; Thu, 7 May 2015 11:51:09 +0100
Message-ID: <20150507125109.179541ri1n6c7zj1@webmail.inescporto.pt> (sfid-20150507_125732_632460_E9492B10)
Date: Thu, 07 May 2015 12:51:09 +0200
From: =?iso-8859-1?b?TeFyaW8=?= Lopes <mjlopes@inesctec.pt>
To: linux-wireless@vger.kernel.org
Subject: Access to ath9k tx/rx buffers
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all.

I need access to transmission and reception buffers of ath9k driver,  
in order to create shorter link than that one provided by libpcap by  
manipulating those buffers from user space software. I did some  
research and found things such as ioctl, netlink, mmap, amongst  
others, but they didn't work as needed.
Can someone give me some hint?

Thanks for your time.


BR,
Mário Lopes.





----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
