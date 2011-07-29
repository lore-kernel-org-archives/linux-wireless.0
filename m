Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35223 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab1G2Gx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 02:53:56 -0400
Date: Fri, 29 Jul 2011 12:24:07 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/9] ath9k_hw: Fix incorrect Tx control power in AR9003
 template
Message-ID: <20110729065406.GB2268@vmraj-lnx.users.atheros.com> (sfid-20110729_085359_811516_CC29363C)
References: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1311874176-27569-4-git-send-email-rmanohar@qca.qualcomm.com>
 <CAB=NE6WsBDZTin3t6JsXm6mWYGozsbH48DO08QVYodXg3Ny-ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAB=NE6WsBDZTin3t6JsXm6mWYGozsbH48DO08QVYodXg3Ny-ng@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 28, 2011 at 02:12:49PM -0700, Luis R. Rodriguez wrote:
> On Thu, Jul 28, 2011 at 10:29 AM, Rajkumar Manoharan
> <rmanohar@qca.qualcomm.com> wrote:
> > CTL power data incorrect in ctlPowerData_2G field of ar9300_eeprom.
> > Setting incorrect CTL power in calibration is causing lower tx power.
> > This issue was identified in HT40 mode on channel 6 & 11.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> Is this a stable fix? If so can you please resend with a Cc:
> stable@kernel.org on the commit log message and explain why its a
> stable fix.
>
Yes. The issue is that tx power is shown as 3dBm while operating in channel 6
at HT40+ or channel 11 at HT40- due to CTL powers in the calibration is set to
zero. Will send v2 patch.

--
Rajkumar
