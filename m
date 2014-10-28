Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50641 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759767AbaJ1GXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 02:23:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id B1EBB20AB4
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2014 02:23:42 -0400 (EDT)
Date: Tue, 28 Oct 2014 14:22:31 +0800
From: Greg KH <greg@kroah.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.16 0/7] Backort firmware monitor to 3.16
Message-ID: <20141028062231.GA12676@kroah.com> (sfid-20141028_072348_803852_0F6557EC)
References: <1414476686-3407-1-git-send-email-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414476686-3407-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2014 at 08:11:19AM +0200, Emmanuel Grumbach wrote:
> This patch series allows to use the firmware debugging features
> of iwlwifi on 3.16. These features are already in 3.17.
> 
> I know that this patch series is not compliant with Greg's
> rules for stable patches. It is unlikely that these patches
> will be applied on vanilla 3.16 - I know that.

Good, because I just released the last 3.16-stable-rc kernel, so even if
I wanted to, I wouldn't take these :)

thanks,

greg k-h
