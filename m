Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59473
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbXJMIZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 04:25:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: b43: regression on bcm4318
Date: Sat, 13 Oct 2007 10:24:47 +0200
Cc: Vitaly Bordug <vitb@kernel.crashing.org>,
	"John W. Linville" <linville@redhat.com>,
	linux-wireless@vger.kernel.org
References: <20071013121730.1eef0d93@kernel.crashing.org>
In-Reply-To: <20071013121730.1eef0d93@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710131024.48113.mb@bu3sch.de> (sfid-20071013_092536_830376_B0C81D2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 October 2007 10:17:30 Vitaly Bordug wrote:
> phy1: Failed to select rate control algorithm
> phy1: Failed to initialize rate control algorithm

That's nothing b43 or ssb related.
Compile and load the rc80211_simple module.

-- 
Greetings Michael.
