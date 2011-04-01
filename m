Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:46046 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434Ab1DALXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 07:23:14 -0400
Received: by mail-ey0-f177.google.com with SMTP id 6so1213056eyh.22
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 04:23:10 -0700 (PDT)
Subject: Re: [PATCH 2/5] wl12xx: Clean up the block size alignment code
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301558821-17787-3-git-send-email-ido@wizery.com>
References: <1301558821-17787-1-git-send-email-ido@wizery.com>
	 <1301558821-17787-3-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 14:23:49 +0300
Message-ID: <1301657029.1988.478.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-31 at 10:06 +0200, Ido Yariv wrote:
> Simplify and clean up the block size alignment code:
> 1. Set the block size according to the padding field type, as it cannot
>    exceed the maximum value this field can hold.
> 2. Move the alignment code into a function instead of duplicating it in
>    multiple places.
> 3. In the current implementation, the block_size member can be
>    misleading because a zero value actually means that there's no need to
>    align. Declare a block size alignment quirk instead.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

