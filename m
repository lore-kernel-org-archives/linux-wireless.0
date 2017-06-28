Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56780 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbdF1Rwp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 13:52:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: Do not change bss_type in change_virtual_intf
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1498114972-25712-1-git-send-email-gbhat@marvell.com>
References: <1498114972-25712-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170628175243.AB6CC60AD0@smtp.codeaurora.org> (sfid-20170628_195313_905166_7BCA2C06)
Date: Wed, 28 Jun 2017 17:52:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> When user adds a virtual interface driver will set the
> bss_type to the iface_type given by the user. When
> supplicant is started on the same interface, a call to
> change_virtual_intf will be triggered if if_type is not
> NL80211_IFTYPE_STATION. Here driver should not update
> it's bss_type, because bss_type is intended to indicate
> the original iface_type and changing the same will defeat
> the purpose of creating this interface.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

4d7ab36f0c47 mwifiex: Do not change bss_type in change_virtual_intf

-- 
https://patchwork.kernel.org/patch/9803591/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
