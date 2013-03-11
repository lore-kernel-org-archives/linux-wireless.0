Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:63645 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3CKWpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 18:45:22 -0400
Received: by mail-we0-f182.google.com with SMTP id t57so4176295wey.27
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2013 15:45:20 -0700 (PDT)
Message-ID: <513E5E7D.2050705@gmail.com> (sfid-20130311_234526_026655_85410792)
Date: Mon, 11 Mar 2013 23:45:17 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: greearb@candelatech.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Allow over-riding reg-domain.
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:

> Otherwise, can't get the Sparklan AR9380 NICs to be
> 5Ghz APs, since they are in world-roaming domain by
> default.  Add this to /etc/modprobe.d/ath9k.conf:

You can use atheros branch [0] of iwleeprom [1] to
manipulate the EEPROM.

And you should read: http://wireless.kernel.org/en/users/Drivers/ath#Regulatory


[0] svn co http://iwleeprom.googlecode.com/svn/
[1] http://code.google.com/p/iwleeprom/
