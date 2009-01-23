Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:47221 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753351AbZAWAmW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 19:42:22 -0500
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: iwl3945 regression: associates but no data is transfered
MIME-Version: 1.0
Date: Fri, 23 Jan 2009 01:42:15 +0100
From: <samuel@sortiz.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <4979077B.8090804@lwfinger.net>
References: <87priffb95.fsf@litku.valot.fi> <20090122183448.GC3646@tuxdriver.com> <d7a260e8d188b785d0d2be743c8c5461@localhost> <4979077B.8090804@lwfinger.net>
Message-ID: <a0ea5baee379a280e5a06e81facbb631@localhost> (sfid-20090123_014231_140809_E088ADC6)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 22 Jan 2009 17:55:39 -0600, Larry Finger

<Larry.Finger@lwfinger.net>

wrote:

> samuel@sortiz.org wrote:

> 

>> The bad commit seems to be e32b1b9a33759e8a83ac566c4c43f23ed5d6343b,

>> which

>> is not iwlwifi related.

>> Even though it's an mlme commit, it doesnt seem to affect other drivers

>> (at

>> least b43 and ath5k).

>> I'll come up soon with a proper fix, but for now iwl3945 users should

>> revert that commit locally.

> 

> Something between 2.6.29-rc1 and -rc2 killed b43 and p54usb on my WPA2

> network. My rtl8187

> devices work fine.

> 

> I'm in the process of bisecting right now. Only 1500 commits to go.

Have you tried reverting that commit ?

I actually found that it does break ath5k as well...



Cheers,

Samuel.


