Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab0HGPuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 11:50:40 -0400
Subject: Re: [PATCH 2/4] compat: move va_format to compat-2.6.36.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
In-Reply-To: <1281187941-7168-3-git-send-email-hauke@hauke-m.de>
References: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>
	 <1281187941-7168-3-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 17:50:36 +0200
Message-ID: <1281196236.4431.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-08-07 at 15:32 +0200, Hauke Mehrtens wrote:
> This struct was introduced in kernel 2.6.36 and not 2.6.35.

I'm confused now:

$ git describe 7db6f5fb
v2.6.35-rc1-928-g7db6f5f

johannes

