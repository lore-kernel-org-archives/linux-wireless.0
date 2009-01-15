Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:40567 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZAOCwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 21:52:22 -0500
Received: by rv-out-0506.google.com with SMTP id k40so834481rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 18:52:21 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18798.42051.400380.269490@localhost.localdomain> (sfid-20090115_035225_285116_33A57F14)
Date: Thu, 15 Jan 2009 08:19:39 +0530
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Christoph Hellwig <hch@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [ath9k-devel] [PATCH v4 02/11] ath9k: convert to use bus-agnostic
	DMA routines
In-Reply-To: <1231960632-4452-3-git-send-email-juhosg@openwrt.org>
References: <1231960632-4452-1-git-send-email-juhosg@openwrt.org>
	<1231960632-4452-3-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> Convert to use bus-agnostic DMA routines to make it usable on AHB bus as well.
> 

This pretty much makes the previous patch redundant.

Sujith
