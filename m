Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38375
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbXKSSUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 13:20:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] remove bcm43xx
Date: Mon, 19 Nov 2007 19:18:07 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <20071119171217.557ea31f@morte>
In-Reply-To: <20071119171217.557ea31f@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711191918.07383.mb@bu3sch.de> (sfid-20071119_182058_293056_C7932F0F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 19 November 2007 17:12:17 Stefano Brivio wrote:
> Remove bcm43xx. Fix some left-over URLs and ifdefs in b43 and b43legacy
> drivers.
> 

Stefano, please send the fixes for b43 and b43legacy as a seperate
patch, as they have to go into 2.6.24.


-- 
Greetings Michael.
