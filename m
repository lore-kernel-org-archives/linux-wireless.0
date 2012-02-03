Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44936 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab2BCGEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 01:04:10 -0500
Date: Fri, 3 Feb 2012 11:34:26 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>
Subject: Re: [PATCH 1/2] ath9k: recover the chip from tx/rx stuck
Message-ID: <20120203060424.GB15811@vmraj-lnx.users.atheros.com> (sfid-20120203_070414_838426_A3A1B4DD)
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
 <20265.65072.546108.448327@gargle.gargle.HOWL>
 <20120202035652.GB25988@vmraj-lnx.users.atheros.com>
 <20266.3200.403302.486325@gargle.gargle.HOWL>
 <CAJ-VmomK0cD5rYbSYOQ7xwJLADdbD=a4JVG1bcd4QdTpV+uN2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAJ-VmomK0cD5rYbSYOQ7xwJLADdbD=a4JVG1bcd4QdTpV+uN2Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 02, 2012 at 01:58:21PM -0800, Adrian Chadd wrote:
> On 1 February 2012 20:09, Sujith Manoharan <c_manoha@qca.qualcomm.com>wrote:
> 
> 
> > > > I have not reviewed the patch, but to do such workarounds for an entire
> > > > family of chips is overkill. Has it been confirmed that the other
> > > > chips falling under this SREV check require this snafu ?
> > > >
> > > unfortunately this snafu is applicable for all ar9380 MAC based chips ;)
> > > and confirmed the same.
> >
> > Ok. But this stuff really needs to be verified for other chips.
> > These 'poll' workarounds are piling up.
> >
> 
> Hi,
> 
> Is there a bugzilla.kernel.org bug for this particular behaviour? And if
> you can dig up the internal bug number, please  post it privately.
>
No. This issue was originally reported by Google in their setup.

--
Rajkumar
