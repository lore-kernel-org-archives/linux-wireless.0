Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57026
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXIQMzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 08:55:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: b43 warning
Date: Mon, 17 Sep 2007 14:53:32 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070916145716.c21fcd96.akpm@linux-foundation.org>
In-Reply-To: <20070916145716.c21fcd96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709171453.32463.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 September 2007 23:57:16 Andrew Morton wrote:
> drivers/net/wireless/b43/xmit.c: In function 'generate_txhdr_fw4':
> drivers/net/wireless/b43/xmit.c:189: warning: comparison is always true due to limited range of data type

This is caused by a mac80211 change. It's nonfatal and I'll fix that, soon.

-- 
Greetings Michael.
