Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:50381 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753498AbaCKSIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 14:08:46 -0400
Message-ID: <1394561322.20021.5.camel@joe-AO722> (sfid-20140311_190849_753905_9AC456E4)
Subject: Re: [PATCH] ath10k: unify warning messages in mac.c
From: Joe Perches <joe@perches.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Date: Tue, 11 Mar 2014 11:08:42 -0700
In-Reply-To: <531F4E3F.3020606@candelatech.com>
References: <20140303154327.1290.67278.stgit@potku.adurom.net>
	 <CA+BoTQmQndikH5uPDwBpstp9KmcD3tmHSGP5NpEreYEOtRm0sw@mail.gmail.com>
	 <8761nv44nd.fsf@kamboji.qca.qualcomm.com>
	 <87k3c1gf35.fsf@kamboji.qca.qualcomm.com>
	 <531F49F2.3030408@candelatech.com> <1394559971.20021.1.camel@joe-AO722>
	 <531F4E3F.3020606@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-11 at 10:56 -0700, Ben Greear wrote:
> the driver may want to always show some interesting
> thing and so put it at KERN_ERR when in fact is not a real error

I think that's bad policy.

> that the user should be concerned about (think firmware version,
> for instance)

KERN_INFO is exactly for that.

