Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37966 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYLQQAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 11:00:24 -0500
Date: Wed, 17 Dec 2008 10:48:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
Subject: Re: [RFC] b43: rework rfkill code
Message-ID: <20081217154800.GA12679@tuxdriver.com> (sfid-20081217_170030_769021_5E4233D5)
References: <20081210150935.GA10927@srcf.ucam.org> <4941E863.50703@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4941E863.50703@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 11, 2008 at 10:28:19PM -0600, Larry Finger wrote:
> Matthew Garrett wrote:
> > I've reworked the rfkill code in b43. This ought to be more consistent 
> > with the other drivers and it seems to work on the machines I've tested 
> > it on here, but it'd be good to get some feedback.

<snip>

> > How does this look to people?
> 
> All this discussion about hard vs soft rfkill makes my head hurt and I have
> stopped reading those posts.
> 
> Correction to my earlier post. If the system is booted with the RF switch off,
> the LED is on, whereas it should be off. The original code works correctly.

Based on the above, I'm dropping this patch.  Please submit a
non-regressing version! :-)

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
