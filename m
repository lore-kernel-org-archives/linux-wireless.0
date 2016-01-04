Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38168 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbcADOZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 09:25:32 -0500
Date: Mon, 4 Jan 2016 17:25:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/3] rsi: Delete unnecessary variable initialisations in
 rsi_send_mgmt_pkt()
Message-ID: <20160104142513.GL5284@mwanda> (sfid-20160104_152538_261599_F4244E1D)
References: <566ABCD9.1060404@users.sourceforge.net>
 <5687E169.4070704@users.sourceforge.net>
 <5687E203.1070404@users.sourceforge.net>
 <20160104092857.GD5284@mwanda>
 <87poxhiivf.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <87poxhiivf.fsf@nemi.mork.no>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 04, 2016 at 02:17:40PM +0100, Bjørn Mork wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
> > Please stop sending cleanup patches, Markus.  Just send fixes.
> 
> Thanks for your continued but unwarranted belief in AI.
> 

I always tell people that I am very mechanical and you can rely on me to
send predictable responses...

> Do you mind if I remind you of https://lkml.org/lkml/2014/11/3/162 ?
> I am sure there are lots and lots of other examples.  There is no reason
> to believe this will ever stop.  He just goes into Eliza mode.

Yup.

I feel some sense of responsibility for any patches where kernel-janitors
is on the CC but I'm having a hard time dealing with all of Markus's
patches.  Normally you just respond to the first patch and people change
the later patches but, as you put it, Markus just goes into ELIZA mode.

regards,
dan carpenter

