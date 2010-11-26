Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:44662 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab0KZNoE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 08:44:04 -0500
Subject: Re: [PATCH 1/2] wl1271: use debugfs_remove_recursive
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1290595996-2049-1-git-send-email-eliad@wizery.com>
References: <1290595996-2049-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 15:44:25 +0200
Message-ID: <1290779065.15341.15.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-24 at 12:53 +0200, ext Eliad Peller wrote:
> Documentation/filesystems/debugfs.txt:
> """
> Once upon a time, debugfs users were required to remember the dentry pointer
> for every debugfs file they created so that all files could be cleaned up.
> We live in more civilized times now, though, and debugfs users can call:
> 
>     void debugfs_remove_recursive(struct dentry *dentry);
> """
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied the series and pushed, thank you!

-- 
Cheers,
Luca.

