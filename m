Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4210 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaLXHyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 02:54:49 -0500
Date: Wed, 24 Dec 2014 13:24:29 +0530
From: Rajkumar <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 8/8] ath10k: ath10k: add support to send delba
Message-ID: <20141224075426.GA17103@qca.qualcomm.com> (sfid-20141224_085452_295418_4941FCF3)
References: <1418972099-5296-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1418972099-5296-9-git-send-email-rmanohar@qti.qualcomm.com>
 <1419142431590.38389@qti.qualcomm.com>
 <87d27ag65n.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87d27ag65n.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 23, 2014 at 09:46:28AM +0200, Kalle Valo wrote:
> "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com> writes:
> 
> >> Subject: [PATCH 8/8] ath10k: ath10k: add support to send delba
> >> 
> >> This per-station debugfs entry helps to send delba in manual mode
> >> for debugging purpose. It accepts tid, initiator and reason code
> >> as inputs.
> > Kalle,
> >
> > Subject needs small correction (ath10k: ath10k:). Do you want
> > me send v2 patch for this change?
> 
> No need to send v2, I can do the change myself. But I noticed that you
> already sent it :)
> 
> But in the future please don't resubmit individual patches, that's just
> too error prone. Instead just resubmit the whole series.
> 
Agree... I will resend the whole series. Recently separate WMI ops for 10.2.4
is added. So newer WMI APIs has to be registered in 10.2.4 table.

Will send v2 series.

-Rajkumar
