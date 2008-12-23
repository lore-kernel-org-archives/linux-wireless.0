Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55274 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbYLWFZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 00:25:35 -0500
From: "Xu, Martin" <martin.xu@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 23 Dec 2008 13:25:20 +0800
Subject: ath5k:  whether "txpower off" is supported ? 
Message-ID: <9F0C1DB20AFA954FA1DA05309350433D44333C66@pdsmsx503.ccr.corp.intel.com> (sfid-20081223_062601_224407_8D06FF68)
References: <20081223050006.3710.98311.stgit@ct.roinet.com>
In-Reply-To: <20081223050006.3710.98311.stgit@ct.roinet.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi 
I found that iwconfig txpower off can not work on ath5k driver. 
Ath5k driver(drivers/net/wireless/ath5k/base.c: ath5k_config() ) does not implement the txpower features.
Some one can confirm me whether txpower off feature has been implemented? If not, why? It is because of the HW limitation? Thanks!
BTW:
Where can I found the ath5k HW spec? Thanks!
