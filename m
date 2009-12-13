Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from telepathy.SEAS.UPENN.EDU ([158.130.68.71]:47755 "HELO
	telepathy.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932216AbZLMCeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 21:34:17 -0500
Received: from understudy.seas.upenn.edu (understudy.seas.upenn.edu [158.130.67.161])
	by telepathy.seas.upenn.edu (8.13.6/8.13.6) with ESMTP id nBD26sVO024284
	for <linux-wireless@vger.kernel.org>; Sat, 12 Dec 2009 21:06:59 -0500
Received: from understudy.seas.upenn.edu (LOCALHOST.upenn.edu [127.0.0.1])
	by understudy.seas.upenn.edu (8.13.6/8.13.6) with ESMTP id nBD26sag028167
	for <linux-wireless@vger.kernel.org>; Sat, 12 Dec 2009 21:06:54 -0500
Received: (from wwwrun@localhost)
	by understudy.seas.upenn.edu (8.13.6/8.13.1/Submit) id nBD26sGn028166
	for linux-wireless@vger.kernel.org; Sat, 12 Dec 2009 21:06:54 -0500
Message-ID: <20091212210654.1417577afun9td0k@webmail.seas.upenn.edu>
Date: Sat, 12 Dec 2009 21:06:54 -0500
From: xiaozhou@seas.upenn.edu
To: linux-wireless@vger.kernel.org
Subject: Multi-channel and Multi-interface Wireless Network
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I want to do some experiments on Multi-channel and Multi-interface  
Wireless Network. I know ath5k supports channel switching very well,  
and we can use multiple interface to receive data packets. But I can  
only use the first interface to send packets.

Does ath5k supports multi-interface communications? eg. one node can  
send packets on multiple interfaces with different channels at the  
same time. Or does anyone have experience or ideas about how to hack  
the kernel and drivers to it?

I'd be really appreciated for your help and suggestions. Thanks a lot!

Best,

Xiaozhou
