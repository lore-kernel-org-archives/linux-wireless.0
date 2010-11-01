Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.ext.nokia.com ([147.243.128.24]:49867 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab0KANY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 09:24:56 -0400
Subject: Re: [PATCH 2/2] wl1271: add recover testmode command
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288181398-2358-2-git-send-email-eliad@wizery.com>
References: <1288181398-2358-1-git-send-email-eliad@wizery.com>
	 <1288181398-2358-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 15:24:53 +0200
Message-ID: <1288617893.20937.10.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-27 at 14:09 +0200, ext Eliad Peller wrote:
> add RECOVER testmode command.
> this command triggers a recovery sequence (by enqueueing a recovery_work).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

So, the point of this patch is to allow hardware recovery from the
userspace? In what kind of scenario do you need this?


-- 
Cheers,
Luca.

