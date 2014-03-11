Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:47704 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753189AbaCKRqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 13:46:16 -0400
Message-ID: <1394559971.20021.1.camel@joe-AO722> (sfid-20140311_184620_126793_3CBA2458)
Subject: Re: [PATCH] ath10k: unify warning messages in mac.c
From: Joe Perches <joe@perches.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Date: Tue, 11 Mar 2014 10:46:11 -0700
In-Reply-To: <531F49F2.3030408@candelatech.com>
References: <20140303154327.1290.67278.stgit@potku.adurom.net>
	 <CA+BoTQmQndikH5uPDwBpstp9KmcD3tmHSGP5NpEreYEOtRm0sw@mail.gmail.com>
	 <8761nv44nd.fsf@kamboji.qca.qualcomm.com>
	 <87k3c1gf35.fsf@kamboji.qca.qualcomm.com>
	 <531F49F2.3030408@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-11 at 10:37 -0700, Ben Greear wrote:
> but I would also suggest giving user a clue as to the
> severity.  Something starting with 'failed' or 'warning' is pretty obvious.

Isn't that the whole point of KERN_<LEVEL>?

I think duplicating it is pointless.

