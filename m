Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49404 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab1LGPPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 10:15:20 -0500
Date: Wed, 7 Dec 2011 10:02:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, compat@orbit-lab.org,
	Paul Stewart <pstew@google.com>,
	Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [RFC v2 2/2] cfg80211: Restore orig channel values upon
 disconnect
Message-ID: <20111207150202.GA2555@tuxdriver.com> (sfid-20111207_161523_946614_FCEF3498)
References: <1322518991-7040-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1322518991-7040-3-git-send-email-mcgrof@qca.qualcomm.com>
 <20111207140406.GA13140@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111207140406.GA13140@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2011 at 07:34:08PM +0530, Rajkumar Manoharan wrote:
> On Mon, Nov 28, 2011 at 05:23:11PM -0500, Luis R. Rodriguez wrote:
> > From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > 
> > When we restore regulatory settings the world regulatory domain
> > is properly reset on cfg80211 (or user prefered regulatory domain)
> > but we were never setting back channel values for drivers that use
> > WIPHY_FLAG_CUSTOM_REGULATORY. Set these values up again by using
> > the orig_ channel parameters.
> > 
> > This fixes restoring custom regulatory settings upon disconnect
> > events.
> > 
> > Cc: compat@orbit-lab.org
> > Cc: Paul Stewart <pstew@google.com>
> > Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > Cc: Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> > ---
> >  net/wireless/reg.c |   20 ++++++++++++++++++++
> >  1 files changed, 20 insertions(+), 0 deletions(-)
> > 
> John,
> 
> Can you please push these two RFC patches?
> 
> --
> Rajkumar

Can you resend them?

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
