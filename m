Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36093 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbdHWVE6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 17:04:58 -0400
Received: by mail-io0-f170.google.com with SMTP id p141so4609419iop.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Aug 2017 14:04:58 -0700 (PDT)
Date: Wed, 23 Aug 2017 16:04:55 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless-regdb: Update regulatory document
 references for Taiwan (TW)
Message-ID: <20170823210455.3pxj4pzuuvshtsnn@ubuntu-xps13> (sfid-20170823_230502_091505_91BB241A)
References: <20170808033804.6053-1-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170808033804.6053-1-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 08, 2017 at 11:38:03AM +0800, Chen-Yu Tsai wrote:
> Taiwan's Ministry of Transportation and Communications updated its
> frequency allocation rules again on 2017/02/22. The amended articles
> are not related to this database, but the link should be kept up to
> date, as the old one is no longer accessible.
> 
> Taiwan's regulatory body, NCC, published its updated technical
> regulatory standard for low-power radio frequency devices, LP0002.
> The URL has not changed. The new standard opens up more bandwidth
> for 5g U-NII WiFi and 60g WiGig devices. Transmission power for
> 5.25 ~ 5.35 GHz is also increased, but this was already covered
> in commit 9a618d9b5fb2 ("wireless-regdb: Update 5 GHz rules for
> Taiwan (TW) to follow US").
> 
> This patch updates the link and comments for the rules and standards,
> and also adds inline comments referencing the governing section of the
> LP0002 standard for each band.
> 
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Applied both patches, thanks!
