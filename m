Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:9683 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259AbbBFQHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 11:07:00 -0500
Message-ID: <54D4E6A0.2030300@broadcom.com> (sfid-20150206_170706_161382_357F1443)
Date: Fri, 6 Feb 2015 17:06:56 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Ben Adler <ben@phoenix-aerial.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4330 linux support
References: <54D3FF89.502@phoenix-aerial.com> <54D4851F.8020402@broadcom.com> <54D4D37C.2060007@phoenix-aerial.com>
In-Reply-To: <54D4D37C.2060007@phoenix-aerial.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/15 15:45, Ben Adler wrote:
> It seems like the debug options haven't really added much detail to
> dmesg

You probably don't have CONFIG_BRCMDBG selected in your .config.

Regards,
Arend
