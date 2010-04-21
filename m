Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46147 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab0DUNPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 09:15:14 -0400
Date: Wed, 21 Apr 2010 09:06:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"doug.dahlby" <Doug.Dahlby@atheros.com>,
	Atheros Internal ath9k development team
	<ath9k-devel@atheros.com>, Cliff Holden <Cliff.Holden@atheros.com>,
	Zhifeng Cai <zhifeng.cai@atheros.com>,
	Pavel Roskin <proski@gnu.org>
Subject: Re: ath9k initvals-tool - integrity checks | reformat | synchronize
Message-ID: <20100421130658.GC5072@tuxdriver.com>
References: <w2v43e72e891004210029g15eaf50fwbca39a73b7c46268@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <w2v43e72e891004210029g15eaf50fwbca39a73b7c46268@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 21, 2010 at 12:29:26AM -0700, Luis R. Rodriguez wrote:
> In the v2 patch cover letter for AR9003 I noted how I had started some
> simple initval userspcae tool to check the integrity of the initvals.
> Since we also had some discussions about the possible format changes
> for it I've gone ahead and extended the same tool to also reformat our
> initvals to any format we like and at the same time allowing us to
> verify the integrity is kept. This same tool can now be used by us at
> Atheros to check for changes quickly between our Atheros HAL and the
> ath9k_hw module. I've written some docs how to do all this here:
> 
> http://wireless.kernel.org/en/users/Drivers/ath9k_hw/initvals-tool

Just as an aside, I'd like to thank you for the amount of information
you have added to the Linux Wireless wiki.  It is a really great
resource for our community.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
