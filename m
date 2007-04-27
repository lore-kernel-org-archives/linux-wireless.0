Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42957
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195AbXD0UWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 16:22:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: don't export linux/ieee80211.h
Date: Fri, 27 Apr 2007 22:22:21 +0200
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <200704271554.55770.flamingice@sourmilk.net>
In-Reply-To: <200704271554.55770.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704272222.21772.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 April 2007 21:54:55 Michael Wu wrote:
> From: Michael Wu <flamingice@sourmilk.net>
> 
> The definitions in linux/ieee80211.h don't need to be exported.
> 
> Signed-off-by: Michael Wu <flamingice@sourmilk.net>

Whether they should be exported or not...
Why change all __u8 to u8? I don't see the point.

-- 
Greetings Michael.
