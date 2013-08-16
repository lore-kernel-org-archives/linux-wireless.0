Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34871 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab3HPDFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 23:05:48 -0400
Date: Thu, 15 Aug 2013 20:14:52 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Arik Nemtsov <arik@wizery.com>, backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Subject: Re: [PATCH] backports: rename some mem functions to not break custom
 kernels
Message-ID: <20130816031450.GC9574@garbanzo.do-not-panic.com> (sfid-20130816_050558_486551_184CBB67)
References: <1376466485-25796-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376466485-25796-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 14, 2013 at 10:48:05AM +0300, Arik Nemtsov wrote:
> When custom patches are cherry-picked to a kernel, some symbols exported
> by backports may clash with the built-in ones. Rename the backports
> symbols using the standard backport_ prefix to prevent that.
> 
> The offending symbols were exported by the patch below:
> 
> commit 2ce5c22448bb45998318267c00b5d6ef9cff3170
> Author: Hauke Mehrtens <hauke@hauke-m.de>
> Date:   Thu Jun 6 13:48:04 2013 +0200
> 
>     backports: backport some memory functions
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>

Thanks, applied and pushed. Next time please add
the backports@vger.kernel.org list.

  Luis
