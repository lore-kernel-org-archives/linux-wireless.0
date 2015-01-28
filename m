Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44714 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760614AbbA1Gw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 01:52:28 -0500
Message-ID: <1422447728.16899.7.camel@pe-lt950> (sfid-20150128_075234_910157_11AC36F0)
Subject: Re: [PATCH v2] mwifiex: set netif carrier off in ndo_open
From: Avinash Patil <patila@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stable <stable@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Date: Wed, 28 Jan 2015 17:52:08 +0530
In-Reply-To: <871tmgaznd.fsf@kamboji.qca.qualcomm.com>
References: <1421663076-32291-1-git-send-email-patila@marvell.com>
	 <1422360747.20608.5.camel@pe-lt950>
	 <871tmgaznd.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-27 at 09:42 -0800, Kalle Valo wrote:
> Avinash Patil <patila@marvell.com> writes:
> 
> > On Mon, 2015-01-19 at 02:24 -0800, Avinash Patil wrote:
> >> From: Johannes Berg <johannes@sipsolutions.net>
> >> 
> >> This patch adds fix to set carrier state off during ndo_open.
> >> Carrier should be set to ON when device is ready to send data.
> >> In case of station/adhoc interface device is able to transfer
> >> data after successful association/join operation.
> >> For AP this would be after bss_active event.
> >> 
> >> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> >> Signed-off-by: Avinash Patil <patila@marvell.com>
> 
> [...]
> 
> > I do not see this patch in master branch as well as in patchworks
> > pending patchlist. Is this one also dropped? Do you want me to resend
> > this as well while I am sending rebased DFS patches?
> 
> I had accidentally marked this patch as "Not Applicable" in patchwork,
> sorry about that. Good thing that you noticed. I have applied the patch
> now.
> 
Thanks, Kalle.

-Avinash

