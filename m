Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c.6b.1343.static.theplanet.com ([67.19.107.12]:52027 "EHLO
	mail.bitnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZEGInb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 04:43:31 -0400
Received: from [192.168.10.247] (unknown [79.132.226.168])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.bitnet.be (Postfix) with ESMTP id 57F982980B2
	for <linux-wireless@vger.kernel.org>; Thu,  7 May 2009 03:43:27 -0500 (CDT)
Message-ID: <4A029F31.6090405@bitnet.be>
Date: Thu, 07 May 2009 10:43:29 +0200
From: Hans Maes <Hans@bitnet.be>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath5k antenna control patch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Could somebody tell me if there is any reason why the patch implementing 
the ath5k antenna control doesn't seem to be committed yet ?

The original patch : 
http://marc.info/?l=linux-wireless&m=123984229722724&w=4
The revised version : 
http://marc.info/?l=linux-wireless&m=124112144817141&w=4

I've been trying to patch the sources myself, seems to have worked ok 
and even compiled successfully but I'm lacking some knowledge on how to 
now 'properly' test or deploy this newly compiled version of the ath5k 
module to some wireless mesh nodes.

I could probably get it working if I could just use compat-wireless and 
follow the manual, but I don't think the patch has made it there yet.

Regards,

Hans
