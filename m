Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37507 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbcCIM0B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 07:26:01 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wnhuang@google.com" <wnhuang@google.com>
Subject: RE: [PATCH v2] mwifiex: Empty Tx queue during suspend
Date: Wed, 9 Mar 2016 12:25:53 +0000
Message-ID: <a1c1dd015fdc47ca90b5044477856299@SC-EXCH04.marvell.com> (sfid-20160309_132606_405135_86C4C255)
References: <1457436317-15477-1-git-send-email-akarwar@marvell.com>
 <87a8m9ksck.fsf@purkki.adurom.net>
In-Reply-To: <87a8m9ksck.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Kalle Valo
> Sent: Tuesday, March 08, 2016 7:03 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; wnhuang@google.com
> Subject: Re: [PATCH v2] mwifiex: Empty Tx queue during suspend
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > In cfg80211 suspend handler, stop the netif queue and wait until all
> > the Tx queues become empty. Start the queues in resume handler.
> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> 
> The changelog is missing, please always provide one.
> 

I will resend the patch with changelog info.

Regards,
Amitkumar
