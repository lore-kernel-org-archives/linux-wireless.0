Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:60593 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaLRKzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 05:55:25 -0500
Message-ID: <c1f3352bed1f1a2985a5111a077134a5.squirrel@www.codeaurora.org> (sfid-20141218_115529_907790_B6D7FDC0)
In-Reply-To: <87388d2tbn.fsf@purkki.adurom.net>
References: <87388d2tbn.fsf@purkki.adurom.net>
Date: Thu, 18 Dec 2014 12:55:23 +0200
Subject: Re: changes to Linux wireless maintenance
From: "Kalle Valo" <kvalo@codeaurora.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-nfc@ml01.01.org, "David S. Miller" <davem@davemloft.net>,
	"Kalle Valo" <kvalo@codeaurora.org>, lwn@lwn.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:

> Nevertheless, I think it is time for some changes.  I have been
> the wireless maintainer for a long time, and I personally would
> like to develop in a different direction.  Plus, I think that Linux
> will benefit from having some fresh blood involved in more of the
> maintenance duties.  I will be stepping aside to let that happen.

Thanks to you both the Linux wireless subsystem as well as the wireless
community has improved so much from what you started. You will be missed.
Thank you for all your efforts and I hope you still hang around :)

> As for the wireless driver patches, I have asked Kalle Valo
> to handle patch review and merge duties for everything under the
> drivers/net/wireless directory.  This will now include not only the ath
> patches he already manages, but other drivers that don't have trees
> such as mwifiex, rt2x00, rtlwifi, and others.  For consistency, the
> iwlwifi tree will also be merged through Kalle's new tree.  I expect
> that Kalle will announce any relevant details in a follow-up message.

I have created two trees, wireless-drivers and wireless-drivers-next:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git/

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/

The trees work similarly like John's wireless and wireless-next trees, the
former only for important bugfixes to -rc releases and the latter for the
rest going to the next release.

I still need to ask both linux-next and kbuild maintainers to add these
trees to their list of trees to test from, but I hope that to happen in
the next few days.

There's no need to CC me on the patches, I can pick the patches from the
mailing list. Actually in the future I'm hoping to use patchwork[1] for
managing patches, but my access request is still pending in helpdesk's
queue. I'll send a separate email once I start using patchwork. For the
time being I just use email to apply patches.

For ath6kl and ath10k there will be no changes. I will maintain ath.git
tree separately and just periodically merge that tree to
wireless-drivers-next.

I'll try to make this transition period as smooth as possible but some
glitches might happen, like missing patches and so on. So please keep your
eyes open and let me know if you spot any problems or I missed something.

Kalle

[1] https://patchwork.kernel.org/project/linux-wireless/list/


