Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbcERDgu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 23:36:50 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Lenski <dlenski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] rtl8xxxu: Make polling timeout for firmware configurable
References: <1463534086-22353-1-git-send-email-dlenski@gmail.com>
	<1463534086-22353-3-git-send-email-dlenski@gmail.com>
Date: Tue, 17 May 2016 23:36:48 -0400
In-Reply-To: <1463534086-22353-3-git-send-email-dlenski@gmail.com> (Dan
	Lenski's message of "Tue, 17 May 2016 18:14:46 -0700")
Message-ID: <wrfj60uc3ulr.fsf@redhat.com> (sfid-20160518_053652_739599_BB9CBBF7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Lenski <dlenski@gmail.com> writes:
> This patch makes RTL8XXXU_FIRMWARE_POLL_MAX into a configurable module
> parameter, firmware_poll_max.
>
> Signed-off-by: Dan Lenski <dlenski@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

I really see no use for this one - it's an extremely rare case, and not
something that I'd expect anyone ever using.

Again, please submit patches against the correct git tree.

Jes
