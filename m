Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4097 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759138Ab1CDAf7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 19:35:59 -0500
Subject: RE: [PATCH v2] mwifiex: remove PRINTM/HEXDUMP and associated
From: Joe Perches <joe@perches.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <477F20668A386D41ADCC57781B1F704307F5150CCD@SC-VEXCH1.marvell.com>
References: <1299105113-3052-1-git-send-email-bzhao@marvell.com>
	 <1299139646.4338.69.camel@Joe-Laptop>
	 <477F20668A386D41ADCC57781B1F704307F5150CCD@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 16:35:58 -0800
Message-ID: <1299198958.4338.201.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-03 at 11:24 -0800, Bing Zhao wrote:
> For example, I can do "format 'mwifiex cmd' +p" and
> "format 'mwifiex event' +p" to enable debugging for "cmd" and "event" only.

On Thu, 2011-03-03 at 14:04 -0800, Bing Zhao wrote:
> Do you think we should use pr_fmt(fmt) to construct _ddebug descriptor?
>         { KBUILD_MODNAME, __func__, __FILE__, pr_fmt(fmt), __LINE__,            \
> Otherwise, I still have to add "mwifiex: " prefix for every pr_debug() call.

Maybe I misunderstand.  Doesn't this work?
	"module mwifiex format 'event' +p"


