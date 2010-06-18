Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46286 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab0FRGDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 02:03:42 -0400
Received: by pwi1 with SMTP id 1so309755pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 23:03:41 -0700 (PDT)
From: Ray <raystinger@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: Force send a packet in ath5k
Date: Fri, 18 Jun 2010 14:03:36 +0800
Message-Id: <6F3E54FF-677A-4957-A9D4-127E87850218@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1081)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

May I know whats the fastest way to force send a response packet back to someone upon receiving a probe request? I am trying to create a relay sort of experiment which involves two computers running ath5k, comp1 will send a probe request to comp2 and then wait for comp2 to reply with probe response, upon receiving, it will repeat the sending of probe request. I would like to have this done with shortest delay possible and it should be carried out sequentially. I have successfully made comp1 to send probe req to comp2 and it has been correctly received by ath5k_intr(). Now I'm stuck as to where I can send back the response in the shortest delay possible. Anyone has idea how this can be done? Thank you.


Ray