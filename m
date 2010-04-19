Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:48585 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994Ab0DSPx0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 11:53:26 -0400
Subject: Re: [PATCH v3 42/97] ath9k: Make bf_desc of ath_buf opaque
From: Pavel Roskin <proski@gnu.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <4BC8E027.1030807@openwrt.org>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
	 <1271367582-992-43-git-send-email-lrodriguez@atheros.com>
	 <1271455259.16507.43.camel@mj>  <4BC8E027.1030807@openwrt.org>
Content-Type: text/plain
Date: Mon, 19 Apr 2010 11:53:24 -0400
Message-Id: <1271692404.9026.15.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-04-17 at 00:09 +0200, Felix Fietkau wrote:

> > The obvious downside is that bf_desc becomes compatible with pointers of
> > any type.
> Because on AR9300 where it's used, it points to a struct ar9003_txc instead.

OK, fair enough.

-- 
Regards,
Pavel Roskin
