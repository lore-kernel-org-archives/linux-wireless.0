Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:41815 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758838AbZAVXzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:55:50 -0500
Message-ID: <4979077B.8090804@lwfinger.net> (sfid-20090123_005557_893369_3B1D7D40)
Date: Thu, 22 Jan 2009 17:55:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: samuel@sortiz.org
CC: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 regression: associates but no data is transfered
References: <87priffb95.fsf@litku.valot.fi> <20090122183448.GC3646@tuxdriver.com> <d7a260e8d188b785d0d2be743c8c5461@localhost>
In-Reply-To: <d7a260e8d188b785d0d2be743c8c5461@localhost>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

samuel@sortiz.org wrote:

> The bad commit seems to be e32b1b9a33759e8a83ac566c4c43f23ed5d6343b, which
> is not iwlwifi related.
> Even though it's an mlme commit, it doesnt seem to affect other drivers (at
> least b43 and ath5k).
> I'll come up soon with a proper fix, but for now iwl3945 users should
> revert that commit locally.

Something between 2.6.29-rc1 and -rc2 killed b43 and p54usb on my WPA2 network. My rtl8187
devices work fine.

I'm in the process of bisecting right now. Only 1500 commits to go.

Larry


