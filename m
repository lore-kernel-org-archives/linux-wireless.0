Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38219 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3CRLwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 07:52:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath6kl-devel@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] ath6kl: add an extra band check to ath6kl_wmi_beginscan_cmd()
References: <20130310055129.18916.96742.stgit@localhost6.localdomain6>
Date: Mon, 18 Mar 2013 13:52:01 +0200
In-Reply-To: <20130310055129.18916.96742.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Sun, 10 Mar 2013 07:51:29 +0200")
Message-ID: <87hak97wny.fsf@kamboji.qca.qualcomm.com> (sfid-20130318_125212_339537_31DB01D5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Dan reported that smatch found a possible issue in ath6kl_wmi_beginscan_cmd()
> where we might access sc->supp_rates beyond the end. It shouldn't happen as
> ar->wiphy->bands always have just the first two bands set, but add an extra
> check just to be sure.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Both patches applied. Thank Dan.

-- 
Kalle Valo
