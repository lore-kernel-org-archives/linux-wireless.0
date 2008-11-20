Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33792 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbYKTCQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 21:16:14 -0500
Date: Wed, 19 Nov 2008 21:00:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [GIT PATCH] rfkill fixes for 2.6.28-rc3
Message-ID: <20081120020054.GB13464@tuxdriver.com> (sfid-20081120_031618_924697_2CA0A401)
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br> <200811031747.16326.IvDoorn@gmail.com> <20081103170243.GB2417@khazad-dum.debian.net> <200811031820.41165.IvDoorn@gmail.com> <20081112211530.GH2411@tuxdriver.com> <20081114001624.GA10002@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081114001624.GA10002@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 13, 2008 at 10:16:24PM -0200, Henrique de Moraes Holschuh wrote:
> On Wed, 12 Nov 2008, John W. Linville wrote:
> > Still, I don't see how they qualify for 2.6.28.  How serious do you
> > think this potential problem really is?
> 
> It is not very grave, but it IS annoying...  The only reason I don't
> outright call it a regression, is that it was so broken before, it is just
> broken in a different way without these patches.

I'm sorry, but I would prefer not to bother with this for 2.6.28.
Could you send versions intended for wireless-testing/2.6.29?

Thanks,

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
