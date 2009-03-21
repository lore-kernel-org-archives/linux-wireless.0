Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out25.alice.it ([85.33.2.25]:4901 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZCUVEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 17:04:46 -0400
Message-ID: <49C55670.6010705@jumpy.it> (sfid-20090321_220449_966663_F7B44124)
Date: Sat, 21 Mar 2009 22:04:48 +0100
From: ciccio <aspcicc@jumpy.it>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: bug notify
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

computer acer 5737z that uses atheros AR928X wireless adapter
PCLinuxos 2009.1 installed that uses kernel 2.6.26.8
I have downloaded compat-wireless-old and i obtain errore during make:

***ERROR: CONFIG_MAC(="!!_QOS is somehow enabled in your kernel, how did 
that happen.....................
...........

Goodbye

I have installed old kernel 2.6.24 and make goes good but at the end of 
make install i receive an error in depmod but ath9.ko is compiled and 
installed and works.

Now i want to try sidux that uses kernel 2.6.28

Goodbye
