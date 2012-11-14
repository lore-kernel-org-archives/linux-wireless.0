Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:38927 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2KNSSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 13:18:10 -0500
Date: Wed, 14 Nov 2012 17:29:53 +0000 (GMT)
From: Chris Wilson <chris@aptivate.org>
To: backports@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: compat-drivers 3.7-rc1: cfg80211 fails to load on 3.0.0-26-generic-pae
 [AV#3438]
Message-ID: <alpine.DEB.2.02.1211141726190.23195@lap-x201> (sfid-20121114_191814_108939_8DB1E636)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear developers,

I'm trying to use compat-drivers to gain support for the Intel Centrino 
Wireless-N (iwlwifi driver) on the Ubuntu Oneiric kernel backported to 
Lucid (3.0.0-26-generic-pae). The driver compiles but fails to install, 
with the following error:

[  578.661869] Compat-drivers backport release: compat-drivers-v3.7-rc1-6
[  578.661879] Backport based on linux-stable.git v3.7-rc1
[  578.661885] compat.git: linux-stable.git
[  578.664089] cfg80211: Unknown symbol simple_open (err 0)

Does anyone know what this means? Did Ubuntu change the kernel enough that 
compat-drivers compatibility layer is confused?

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

