Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:51497 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbYENEhj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 00:37:39 -0400
Subject: Re: First patch to mrv8k driver?
From: Pavel Roskin <proski@gnu.org>
To: John Daiker <daikerjohn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <482A3961.2010906@gmail.com>
References: <482A3961.2010906@gmail.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 00:37:37 -0400
Message-Id: <1210739857.2721.51.camel@rd> (sfid-20080514_063747_584933_DB25E36E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-13 at 17:59 -0700, John Daiker wrote:
> Hey All,
> 
> My first patch for the mrv8k driver.  My machine locks up when I try to 
> load a firmware, so I'm not sure if this patch helps anybody or not.

I don't see any changes for mrv_reg_read32() claimed in the description.
In fact, I don't see any changes to the code except comments and
messages.  I don't see how it can help against lockups, unless you
missed some part of the patch.

You may want to spell check your patch, including the description,
especially if the patch is fixing spelling mistakes made by others.

-- 
Regards,
Pavel Roskin
