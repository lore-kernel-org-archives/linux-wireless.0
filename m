Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3189 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbXJBSIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 14:08:24 -0400
Date: Tue, 2 Oct 2007 13:37:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Wireless damage [Was: -mm merge plans for 2.6.24]
Message-ID: <20071002173745.GA13280@tuxdriver.com> (sfid-20071002_190828_163288_E016A865)
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <4701FC79.3060608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4701FC79.3060608@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 02, 2007 at 10:08:25AM +0200, Jiri Slaby wrote:
> On 10/01/2007 11:22 PM, Andrew Morton wrote:
> > git-net-vs-git-wireless.patch
> 
> Hum, latest wireless-2.6?h=everything already had a proper fix when this patch
> was merged. But pull/push is stuck somewhere :(.

It is in mm-master as well.  No doubt it was just a little too late
for akpm's pull.

> > net-add-ath5k-wireless-driver-fix.patch
> 
> let it live in -mm (wireless-2.6) so far.

Aye.

John
-- 
John W. Linville
linville@tuxdriver.com
