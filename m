Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0121.outbound.protection.outlook.com ([104.47.34.121]:35584
	"EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752073AbcHOIny (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 04:43:54 -0400
From: Wright Feng <wefe@cypress.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	Arend Van Spriel <arend.vanspriel@broadcom.com>
CC: "brcm80211-dev-list.pdl@broadcom.com"
	<brcm80211-dev-list.pdl@broadcom.com>,
	"franky.lin@broadcom.com" <franky.lin@broadcom.com>,
	"hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
	"pieterpg@broadcom.com" <pieterpg@broadcom.com>,
	"Chi-Hsien Lin" <chln@cypress.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] brcmfmac: shut down AP and set IBSS mode only on primary
 interface
Date: Mon, 15 Aug 2016 08:11:07 +0000
Message-ID: <DM5PR06MB28259759C91C4ACBDB719EF9D9120@DM5PR06MB2825.namprd06.prod.outlook.com> (sfid-20160815_104400_531728_E3DBD173)
References: <20160810080100.GA10783@cypress.com>
	<4d60ec5e-6462-372a-2d3c-5770493e7e98@broadcom.com>
	<DM5PR06MB28258E50D25AE4221558BA28D91D0@DM5PR06MB2825.namprd06.prod.outlook.com>
	<cab5a204-3487-ebe6-7e82-ca6dbb04ff40@broadcom.com>
 <871t1qe9u3.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871t1qe9u3.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle and Arend,

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Monday, August 15, 2016 4:05 PM
> To: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Cc: Wright Feng <wefe@cypress.com>; brcm80211-dev-
> list.pdl@broadcom.com; franky.lin@broadcom.com;
> hante.meuleman@broadcom.com; pieterpg@broadcom.com; Chi-Hsien Lin
> <chln@cypress.com>; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] brcmfmac: shut down AP and set IBSS mode only on
> primary interface
>
> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>
> >> This message and any attachments may contain Cypress (or its
> >> subsidiaries) confidential information. If it has been received in
> >> error, please advise the sender and immediately delete this message.
> >
> > Is there any way for you to get rid of this foot note. It may keep
> > Kalle from taking this patch.
>
> Correct. I'll automatically drop patches with these kind of notices.
I've removed the foot note and sent the [PATCH v2] to you on 8/11.
Is that okay to you?
>
> --
> Kalle Valo

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
