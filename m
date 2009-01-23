Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:49553 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754397AbZAWBGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 20:06:50 -0500
Message-ID: <4979181E.1070401@lwfinger.net> (sfid-20090123_020654_940088_A67D0D27)
Date: Thu, 22 Jan 2009 19:06:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: samuel@sortiz.org
CC: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 regression: associates but no data is transfered
References: <87priffb95.fsf@litku.valot.fi> <20090122183448.GC3646@tuxdriver.com> <d7a260e8d188b785d0d2be743c8c5461@localhost> <4979077B.8090804@lwfinger.net> <a0ea5baee379a280e5a06e81facbb631@localhost>
In-Reply-To: <a0ea5baee379a280e5a06e81facbb631@localhost>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

samuel@sortiz.org wrote:
> Have you tried reverting that commit ?
> I actually found that it does break ath5k as well...

No - as I was bisecting, I thought I'd keep going; however, that sounds like a good idea
that might save some time.

I'll report ASAP.

Larry
