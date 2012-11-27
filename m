Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:46444 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756342Ab2K0UPp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 15:15:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: =?iso-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Tue, 27 Nov 2012 12:15:34 -0800
Subject: RE: [PATCH] mwifiex: advertise GreenField, 40MHz intolerance
 support to cfg80211
Message-ID: <477F20668A386D41ADCC57781B1F70430D1367C9E3@SC-VEXCH1.marvell.com> (sfid-20121127_211550_533764_5E7B340E)
References: <1353986913-3087-1-git-send-email-bzhao@marvell.com>
 <CA+XFjipSqoh4Sj3Dup3cw-YMF1vs6NN-Eb3aV_m_Xs2kY6T_ig@mail.gmail.com>
In-Reply-To: <CA+XFjipSqoh4Sj3Dup3cw-YMF1vs6NN-Eb3aV_m_Xs2kY6T_ig@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gábor,

> > +#define ISENABLED_40MHZ_INTOLARENT(Dot11nDevCap) (Dot11nDevCap & BIT(8))
> 
> Typo?

Thanks for catching this error. V2 has been sent.

Regards,
Bing

