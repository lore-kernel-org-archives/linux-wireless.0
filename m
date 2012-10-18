Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35627 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701Ab2JRI7k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 04:59:40 -0400
Message-ID: <507FC4F2.8030102@hauke-m.de> (sfid-20121018_105943_995639_2439B68C)
Date: Thu, 18 Oct 2012 10:59:30 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Pontus Fuchs <pontus.fuchs@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org, hch@lst.de,
	s.L-H@gmx.de
Subject: Re: [PATCH v2 0/4] Driver for the ar5523 chipset
References: <1350415769-8271-1-git-send-email-pontus.fuchs@gmail.com>
In-Reply-To: <1350415769-8271-1-git-send-email-pontus.fuchs@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/2012 09:29 PM, Pontus Fuchs wrote:
> Some time ago I found an old USB wireless dongle in my drawer. I was
> surprised it wasn't supported in Linux. Google gave me an old
> unfinished driver created by Christoph Hellwig. Armed with some
> spare time and naivity I picked up where Christoph left in 2007 and
> now it's actually working pretty fine. It does not crash for me and
> throughput is decent.
> 
> It's based on the FreeBSD driver, which in turn is based on the
> reverse engineered Windows driver, hence a very limited feature set.
> Not even HW crypto offload is supported. But at least there is a
> firmware which has a suitable license:
> 
> http://www.freebsd.org/cgi/cvsweb.cgi/src/sys/contrib/dev/uath/ar5523.bin.uu
> 
> Changes v1 to v2:
> 
> * Change to same license as ath9k as suggested by Luis.

Is changing the license so easy? Have you ask all contributers to the
GPL version of this driver, if they are fine with changing the license
especially Christoph Hellwig?

Hauke
