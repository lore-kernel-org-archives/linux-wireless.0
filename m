Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41601 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab1G1VNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 17:13:10 -0400
Received: by qwk3 with SMTP id 3so1551297qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 14:13:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311874176-27569-4-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com> <1311874176-27569-4-git-send-email-rmanohar@qca.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 28 Jul 2011 14:12:49 -0700
Message-ID: <CAB=NE6WsBDZTin3t6JsXm6mWYGozsbH48DO08QVYodXg3Ny-ng@mail.gmail.com> (sfid-20110728_231325_501861_13B01C7F)
Subject: Re: [PATCH 4/9] ath9k_hw: Fix incorrect Tx control power in AR9003 template
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 28, 2011 at 10:29 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> CTL power data incorrect in ctlPowerData_2G field of ar9300_eeprom.
> Setting incorrect CTL power in calibration is causing lower tx power.
> This issue was identified in HT40 mode on channel 6 & 11.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Is this a stable fix? If so can you please resend with a Cc:
stable@kernel.org on the commit log message and explain why its a
stable fix.

  Luis
