Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:37877 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750765AbaJPIuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 04:50:46 -0400
Message-ID: <1413449441.7484.22.camel@perches.com> (sfid-20141016_105110_990535_0FE86341)
Subject: Re: [PATCH 1/1 linux-next] zd1201: replace kmalloc/memset by kzalloc
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 16 Oct 2014 01:50:41 -0700
In-Reply-To: <346236957.6316.1413446930736.open-xchange@webmail.nmp.skynet.be>
References: <1413304831-7203-1-git-send-email-fabf@skynet.be>
	 <1413306955.3269.30.camel@joe-AO725> <87iojm8qxp.fsf@nemi.mork.no>
	 <346236957.6316.1413446930736.open-xchange@webmail.nmp.skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-16 at 10:08 +0200, Fabian Frederick wrote:
> Adding a structure would be a nice design update indeed but this would require
> some testing...Separate patch maybe ?

Of course that'd be fine.


