Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47343 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbZHGPqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 11:46:04 -0400
Date: Fri, 7 Aug 2009 11:36:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT] p54: implement rfkill
Message-ID: <20090807153602.GG7545@tuxdriver.com>
References: <200907192354.15349.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200907192354.15349.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 19, 2009 at 11:54:15PM +0200, Christian Lamparter wrote:
> This patch gets rid of the deprecated radio_enabled
> 
> fwio.c: In function ‘p54_setup_mac’:
> fwio.c:323: warning: ‘radio_enabled’ is deprecated (declared at include/net/mac80211.h:607)

Anyone had a chance to test this?  And report the results to Christian?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
