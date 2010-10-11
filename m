Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:21142 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab0JKL5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 07:57:09 -0400
Subject: Re: [PATCH v2] Ability to set reference clock as module parameter
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Gery Kahn <geryk@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286797309-22786-1-git-send-email-geryk@ti.com>
References: <1286797309-22786-1-git-send-email-geryk@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 14:57:03 +0300
Message-ID: <1286798223.16901.26.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 13:41 +0200, ext Gery Kahn wrote:
> v2 Cleaned changes from development
> 
> Option to set reference clock as module param, debugfs readonly permanent 
> MAC address
> 
> Signed-off-by: Gery Kahn <geryk@ti.com>
> ---

Linville already mentioned once, please *always* include 
"wl1271:" in front of the patch subject, so that we know what the
patches are about.


-- 
Cheers,
Luca.

