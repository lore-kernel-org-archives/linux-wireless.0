Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39061
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbXHSMRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 08:17:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Lock problem with latest b43 patches
Date: Sun, 19 Aug 2007 14:16:25 +0200
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
References: <46C7CACC.2000000@lwfinger.net>
In-Reply-To: <46C7CACC.2000000@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708191416.26192.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 19 August 2007 06:45:00 Larry Finger wrote:
> Using the latest set of 6 patches posted about 5 hours ago, I get the following locking problem with 
> a BCM4311 using WPA-PSK TKIP encryption controlled by NetworkManager:

Are you sure this is caused by my patches? I don't see how that's possible.
How to reproduce?

-- 
Greetings Michael.
