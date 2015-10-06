Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36814 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbbJFNt0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 09:49:26 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: RE: [PATCH] mwifiex: control WLAN and bluetooth coexistence modes
Date: Tue, 6 Oct 2015 13:49:22 +0000
Message-ID: <89e5445d0a0b4eb0ada41e741791c061@SC-EXCH04.marvell.com> (sfid-20151006_154929_925180_E09A7C6E)
References: <1439546371-3218-1-git-send-email-akarwar@marvell.com>
 <8737y1dq48.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8737y1dq48.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Saturday, September 26, 2015 11:23 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam
> Subject: Re: [PATCH] mwifiex: control WLAN and bluetooth coexistence
> modes
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > By default our chip will be in spatial coexistence mode.
> > This patch adds a provision to change it to timeshare mode via sysfs
> > command.
> >
> > Enable timeshare coexistence mode
> >    echo 1 > /sys/class/net/mlan0/timeshare_coex
> >
> > Go back to spacial coexistence mode
> >    echo 0 > /sys/class/net/mlan0/timeshare_coex
> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> 
> Is sysfs acceptable for this? Don't other drivers use debugfs to control
> coexist?
> 

Yes. Other drivers use debugfs to control coexist. I will submit updated version to match this.

Regards,
Amitkumar
