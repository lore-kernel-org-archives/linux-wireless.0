Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45716
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbXITNCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 09:02:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 3/3] adm8211: Adapt to filter configuration API
Date: Thu, 20 Sep 2007 15:02:27 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <20070918213833.8850.90828.stgit@magic.sourmilk.net> <200709191946.43300.mb@bu3sch.de> <200709191703.30877.flamingice@sourmilk.net>
In-Reply-To: <200709191703.30877.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709201502.28215.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 19 September 2007, Michael Wu wrote:
> On Wednesday 19 September 2007 13:46, Michael Buesch wrote:
> > This is broken on BigEndian platforms.
> > use cpu_to_leX().
> Hm, yeah, I remember thinking that at one point and then I forgot about that 
> issue. This patch doesn't introduce it of course.. the code was always broken 
> in that fashion, but this moves it to a new place.

Exactly, I noticed that. So I thought this would be the right time
to finally fix it. ;)
