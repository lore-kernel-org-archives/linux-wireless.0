Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60442 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509Ab3HIRpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 13:45:12 -0400
Date: Fri, 9 Aug 2013 13:41:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Mark Schulte <schultetwin@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] rtlwifi: sparse warnings: cast to restricted type
Message-ID: <20130809174131.GI30925@tuxdriver.com> (sfid-20130809_194521_132427_BEDF5722)
References: <1375254507-26154-1-git-send-email-schultetwin@gmail.com>
 <1375254507-26154-2-git-send-email-schultetwin@gmail.com>
 <51F947A9.3050802@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51F947A9.3050802@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 31, 2013 at 12:21:45PM -0500, Larry Finger wrote:
> On 07/31/2013 02:08 AM, Mark Schulte wrote:
> >Adding type casts to suppress sparse warnings:
> >  * warning: cast to restricted __le32/__le16
> >
> >Signed-off-by: Mark Schulte <schultetwin@gmail.com>
> >---
> >  drivers/net/wireless/rtlwifi/ps.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> I think this patch is OK, but until I get a chance to test it on a
> big-endian machine (PowerBook G4 Titanium), please do not apply it.
> 
> When I tried the patch, I discovered some kind of regression that
> causes a kernel oops with an RTL8192CU device installed. This patch
> is not the problem, but I will need to bisect the oops before I can
> test. The machine takes a long time to build each kernel, thus it
> will probably be a while.

Any word on this?  The patch doesn't look like it should be causing
such problems...?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
