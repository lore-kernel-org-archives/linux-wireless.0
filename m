Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39507 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbbA0FpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 00:45:13 -0500
Message-ID: <1422357290.20608.0.camel@pe-lt950> (sfid-20150127_064516_500693_424CFAA1)
Subject: Re: [PATCH 00/10] mwifiex: DFS support for mwifiex AP
From: Avinash Patil <patila@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	"Marc Yang" <yangyang@marvell.com>,
	Qingshui Gao <gaoqs@marvell.com>
Date: Tue, 27 Jan 2015 16:44:50 +0530
In-Reply-To: <87d265l3u2.fsf@kamboji.qca.qualcomm.com>
References: <1421252138-30157-1-git-send-email-patila@marvell.com>
	 <87d265l3u2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-23 at 11:00 -0800, Kalle Valo wrote:
> Avinash Patil <patila@marvell.com> writes:
> 
> > This patch series adds DFS support for mwifiex AP. Series include
> > patches to handle cfg80211 start_radar_detection and channel_switch
> > handlers. First 5 patches are actually refactoring effort. Patch6-10
> > add these handlers and other DFS handling.
> >
> > Avinash Patil (10):
> >   mwifiex: do not send regulatory update while starting AP
> >   mwifiex: store AP configuration in private structure
> >   mwifiex: update IEs after AP has started
> >   mwifiex: refactor start_ap handler
> >   mwifiex: separate function for parsing head and tail IEs
> >   mwifiex: add cfg80211 start_radar_detection handler
> >   mwifiex: support for channel report for radar detection
> >   mwifiex: handle radar detect event from FW
> >   mwifiex: channel switch support for mwifiex
> >   mwifiex: 11h handling for AP interface
> 
> Patch 5 had conflicts, please rebase.
> 
Hi Kalle,

I will rebase patches on top of master and resend.

Thanks,
Avinash


