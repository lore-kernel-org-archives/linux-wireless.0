Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:55764 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762271AbYFKTRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 15:17:07 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2216204fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 12:17:05 -0700 (PDT)
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Wed, 11 Jun 2008 21:17:00 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <200806060039.48488.m1k0@wp.pl> <20080606034738.9835782d.akpm@linux-foundation.org> <1213151464.7814.630.camel@debian.sh.intel.com>
In-Reply-To: <1213151464.7814.630.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806112117.01544.Michal.Kudla@gmail.com> (sfid-20080611_211711_983091_CCADD47C)
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
Still don't work.
I have tested this patch with and without RFKILL kernel settings
Compressed result files:
config-2.6.26-rc5-no-rfkill.txt
config-2.6.26-rc5-rfkill.txt
dmesg-2.6.26-rc5-no-rfkill.txt
dmesg-2.6.26-rc5-rfkill.txt
are in
http://michal.kudla.googlepages.com/iwlwifi-problem-with-patch-Zhu-Yi.t=
a.bz2



W li=C5=9Bcie datowanym na =C5=9Broda, 11 czerwca 2008, Zhu Yi pisze:
>ZY On Fri, 2008-06-06 at 03:47 -0700, Andrew Morton wrote:
>ZY > > ADDRCONF(NETDEV_UP): wlan0: link is not ready
>ZY > > iwl4965: Error sending REPLY_WEPKEY: enqueue_hcmd failed: -5
>ZY > > mac80211-phy0: failed to remove key (0, ff:ff:ff:ff:ff:ff) from
>ZY > hardware (-5)
>ZY > > iwl4965: Error sending REPLY_TX_PWR_TABLE_CMD: enqueue_hcmd fai=
led:
>ZY > -5
>ZY > > iwl4965: WARNING: Requesting MAC access during RFKILL wakes up =
NIC
>ZY > > iwl4965: WARNING: Requesting MAC access during RFKILL wakes up =
NIC
>ZY
>ZY Looks like a rfkill related problem. Can you please try this patch?
>ZY http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=3D1673
>ZY
>ZY Thanks,
>ZY -yi
>ZY
>ZY


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
