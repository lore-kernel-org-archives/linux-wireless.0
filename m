Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ammma.de ([213.83.39.131]:2098 "EHLO ammma.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751238AbZBLRUV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 12:20:21 -0500
Received: from ammma.net (hydra.ammma.mil [192.168.110.1])
	by ammma.de (8.11.6/8.11.6/AMMMa AG) with ESMTP id n1CHM2I25451
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 18:22:03 +0100
Received: from neo.wg.de (hydra.ammma.mil [192.168.110.1])
	by ammma.net (8.12.11.20060308/8.12.11/AMMMa AG) with ESMTP id n1CHKJUC000989
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 18:20:19 +0100
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id C8F1841A3C7
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 18:20:18 +0100 (CET)
Received: from neo.wg.de ([127.0.0.1])
	by localhost (neo.wg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KL31VhLwVqp8 for <linux-wireless@vger.kernel.org>;
	Thu, 12 Feb 2009 18:20:02 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 498CC42CDD4
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 18:20:00 +0100 (CET)
Message-ID: <20090212181959.11876f8viq636hs0@neo.wg.de> (sfid-20090212_182025_538062_A2E8337D)
Date: Thu, 12 Feb 2009 18:19:59 +0100
From: Jan Schneider <jan@horde.org>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Automatic/manual regulatory settings
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While looking at logs collected for my microcode crash problem I  
noticed that cfg80211 loads US regulatory settings.
If I understand the documentation correctly the actual country should  
be set either by the AP or the device using cfg80211. Neither seems to  
happen, so is it the "correct" way to do this through the  
ieee80211_regdom module parameter? And I wonder how this is supposed  
to happen "idiot-proof" in the future?

Jan.

-- 
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/

