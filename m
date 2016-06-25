Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbcFZOnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2016 10:43:40 -0400
Date: Sat, 25 Jun 2016 15:17:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	davem@davemloft.net, mchehab@kernel.org,
	linux-wireless@vger.kernel.org, glen.lee@atmel.com
Subject: Re: [RFC PATCH v2] MAINTAINERS: remove unreachable people that have
 left Atmel
Message-ID: <20160625221744.GB11632@kroah.com> (sfid-20160626_164451_627052_27A71C4E)
References: <1466892036-10619-1-git-send-email-luisbg@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466892036-10619-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 25, 2016 at 11:00:36PM +0100, Luis de Bethencourt wrote:
> When sending an email regarding a patch to wilc1000, you get the following
> automatic replies:
> "Sung_hoon Cho is no longer with Atmel Corporation."
> "Kang_hee Park is no longer with Atmel Corporation."
> "Dong_ho Shin is no longer with Atmel Corporation."
> "Bo_moon Kim is no longer with Atmel Corporation."
> "Min_su Kim is no longer with Atmel Corporation."
> "Jun_hyuk Lee is no longer with Atmel Corporation."
> 
> Removing these email addresses that don't reach the addressee anymore.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> ---
> 
> Hi,
> 
> Just got the same automatic reply from Glen Lee's address.
> 
> This is unfortunate since it means this driver has no maintainer listed.
> What do people suggest to do in this case?

Let's delete the whole entry please.

And, if no one steps up from Atmel, we might just have to delete the
driver as well :(

thanks,

greg k-h
