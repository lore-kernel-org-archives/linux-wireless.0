Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38480
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbXHAKvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 06:51:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH final] softmac: Fix deadlock of wx_set_essid with assoc work
Date: Wed, 1 Aug 2007 12:51:17 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707312041.04987.mb@bu3sch.de> <1185965301.3083.145.camel@pmac.infradead.org>
In-Reply-To: <1185965301.3083.145.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708011251.17320.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 01 August 2007, David Woodhouse wrote:
> On Tue, 2007-07-31 at 20:41 +0200, Michael Buesch wrote:
> > David, please stresstest this.
> 
> It seemed to survive being left with NetworkManager overnight, which the
> 2.6.22.1 kernel was consistently failing to cope with beforehand.

So John, please apply this.
