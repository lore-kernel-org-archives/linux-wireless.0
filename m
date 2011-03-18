Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54832 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab1CRJBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 05:01:13 -0400
Received: by iwn34 with SMTP id 34so3747660iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 02:01:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D831ACF.5030506@cs.drexel.edu>
References: <4D831ACF.5030506@cs.drexel.edu>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 18 Mar 2011 02:00:53 -0700
Message-ID: <AANLkTimwAb8cEEyZSNUgwxZS2deOLv_ZWa1HOi9cnJTL@mail.gmail.com>
Subject: Re: [PATCH] ath3k: Add ASUS BT Support
To: Lee Trager <lt73@cs.drexel.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2011 at 1:41 AM, Lee Trager <lt73@cs.drexel.edu> wrote:
> The ASUS USB Bluetooth module that comes with my motherboard(ASUS P8P67
> Pro) is simply a re-branded Atheros AR3011. This patch add support for
> it in the driver
>
> Signed-off-by: Lee Trager <lt73@cs.drexel.edu>

Please resubmit with Cc: stable@kernel.org on the commit log entry
(not the e-mail)

  Luis
