Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56686 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbcCCPzc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:55:32 -0500
Message-ID: <1457020529.2044.31.camel@sipsolutions.net> (sfid-20160303_165551_602653_8A1D9946)
Subject: Re: [PATCH V11 1/2] nl80211: add feature for BSS selection support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 03 Mar 2016 16:55:29 +0100
In-Reply-To: <1456947439-28968-1-git-send-email-arend@broadcom.com>
References: <1456947439-28968-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-02 at 20:37 +0100, Arend van Spriel wrote:
> Introducing a new feature that the driver can use to
> indicate the driver/firmware supports configuration of BSS
> selection criteria upon CONNECT command. This can be useful
> when multiple BSS-es are found belonging to the same ESS,
> ie. Infra-BSS with same SSID. The criteria can then be used to
> offload selection of a preferred BSS.
> 
Applied, finally :)

I moved the wiphy supported methods check into parse_bss_select() to
avoid the double error path in the caller, plus some editorial changes.

johannes
