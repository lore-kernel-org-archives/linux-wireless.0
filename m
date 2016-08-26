Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751556AbcHZIZn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 04:25:43 -0400
Date: Fri, 26 Aug 2016 10:22:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mathias Kresin <dev@kresin.me>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: add support for mac addr from device tree
Message-ID: <20160826082228.GA24031@redhat.com> (sfid-20160826_102550_117205_7CE2A5EE)
References: <1472195813-30471-1-git-send-email-dev@kresin.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472195813-30471-1-git-send-email-dev@kresin.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 26, 2016 at 09:16:53AM +0200, Mathias Kresin wrote:
> On some devices the EEPROMs of Ralink Wi-Fi chips have a default Ralink
> MAC address set (RT3062F: 00:0C:43:30:62:00, RT3060F:
> 00:0C:43:30:60:00). Using multiple of these devices in the same network
> can cause nasty issues.
> 
> Allow to override the MAC in the EEPROM with (a known good) one set in
> the device tree to bypass the issue.
> 
> Signed-off-by: Mathias Kresin <dev@kresin.me>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
