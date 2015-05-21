Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from trubo.inescn.pt ([192.35.246.20]:53324 "EHLO trubo.inescn.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbbEUQrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:47:51 -0400
Received: from localhost (localhost [127.0.0.1])
	by trubo.inescn.pt (8.13.8/8.14.3/9) with ESMTP id t4LGln32031474
	for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 17:47:49 +0100
Received: from trubo.inescn.pt ([127.0.0.1])
	by localhost (trubo.inescn.pt [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id iCcK0DzR6vG4 for <linux-wireless@vger.kernel.org>;
	Thu, 21 May 2015 17:47:43 +0100 (WEST)
Received: from grover.inescn.pt (grover.inescn.pt [194.117.24.20])
	by trubo.inescn.pt (8.13.8/8.14.4/3) with ESMTP id t4LGlfX5031453
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 17:47:41 +0100
Received: from grover.inescn.pt (localhost.localdomain [127.0.0.1])
	by grover.inescn.pt (8.13.8/8.13.8/8) with ESMTP id t4LGlfVI018024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 17:47:41 +0100
Received: (from apache@localhost)
	by grover.inescn.pt (8.13.8/8.13.8/Submit) id t4LGlfZY018023
	for linux-wireless@vger.kernel.org; Thu, 21 May 2015 17:47:41 +0100
Message-ID: <20150521184740.12187e87ksbwf9yk@webmail.inescporto.pt> (sfid-20150521_184755_918620_DD7A0CF2)
Date: Thu, 21 May 2015 18:47:40 +0200
From: =?iso-8859-1?b?TeFyaW8=?= Lopes <mjlopes@inesctec.pt>
To: linux-wireless@vger.kernel.org
Subject: Change random waiting time between frames
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all.

Is there a way, by changing ath9k or mac80211 code for example, in  
order to change random waiting time to fixed, which exists between  
consecutive frames sent from same AP/STA/mesh point to another? AFAIK  
it's called "random backoff timer".
It's desired to work both on unicast and broadcast frames.

Thanks for the help.


BR,
Mário Lopes.





----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
