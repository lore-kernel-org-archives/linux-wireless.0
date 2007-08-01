Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35740 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708AbXHAKs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 06:48:26 -0400
Subject: Re: [PATCH final] softmac: Fix deadlock of wx_set_essid with assoc  work
From: David Woodhouse <dwmw2@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200707312041.04987.mb@bu3sch.de>
References: <200707312041.04987.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 11:48:21 +0100
Message-Id: <1185965301.3083.145.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-07-31 at 20:41 +0200, Michael Buesch wrote:
> David, please stresstest this.

It seemed to survive being left with NetworkManager overnight, which the
2.6.22.1 kernel was consistently failing to cope with beforehand.

-- 
dwmw2

