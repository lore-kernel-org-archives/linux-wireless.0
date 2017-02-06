Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35368 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbdBFTWh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 14:22:37 -0500
Received: by mail-io0-f176.google.com with SMTP id j18so73206340ioe.2
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2017 11:22:37 -0800 (PST)
Date: Mon, 6 Feb 2017 13:22:35 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Remove DFS requirement for India (IN)
Message-ID: <20170206192235.GB4004@ubuntu-hedt> (sfid-20170206_202242_138258_31150A25)
References: <1485778112-11236-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485778112-11236-1-git-send-email-jouni@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 30, 2017 at 02:08:32PM +0200, Jouni Malinen wrote:
> The "Indoor Use of low power wireless equipment in the frequency band 5
> GHz (Exemption from Licensing Requirement) Rules, 2005" notification by
> Ministry of Communications and Information Technology (Wireless Planning
> and Coordination Wing) (New Delhi, the 28th January 2005) does not
> mandate use of DFS, so remove the DFS flag from the 5250-5330 MHz band
> in India.
> 
> In addition, increase the TX power limit to 23 dBm to match the 200 mW
> maximum mentioned in the same notification. Also use the exact ranges
> from that notification and enable use of 160 MHz channels in the
> 5150-5350 MHz band.
> 
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>

Applied, thanks.
