Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25516 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZCFKag (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 05:30:36 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 02:30:35 -0800
Subject: Re: [ath9k-devel] [PATCH 0/2] ath9k: fix compile errors
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Gabor Juhos <juhosg@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1236329859-17911-1-git-send-email-juhosg@openwrt.org>
References: <1236329859-17911-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain
Date: Fri, 6 Mar 2009 12:29:33 +0200
Message-ID: <1236335373.16873.1.camel@jm-desktop> (sfid-20090306_113039_618245_A3D6DF39)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-03-06 at 00:57 -0800, Gabor Juhos wrote:
> This set will correct two compilation errors in master-2009-03-04
> of wireless-testing.

Thanks for fixing these and the no-RFKILL build issue! Looks like I
should try to get a build setup for testing ahb.c build myself..

- Jouni


