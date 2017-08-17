Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:35174 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdHQKor (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 06:44:47 -0400
Date: Thu, 17 Aug 2017 04:55:47 -0500
From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Wright Feng <wright.feng@cypress.com>,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH] brcmfmac: add CLM download support
Message-ID: <20170817095546.GA32553@aremote01.aus.cypress.com> (sfid-20170817_124451_321253_60ECAEC1)
References: <1502783044-23715-1-git-send-email-wright.feng@cypress.com>
 <87tw177gv1.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87tw177gv1.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 16, 2017 at 05:00:02PM +0300, Kalle Valo wrote:
> Wright Feng <wright.feng@cypress.com> writes:
> 
> > From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> >
> > The firmware for brcmfmac devices includes information regarding
> > regulatory constraints. For certain devices this information is kept
> > separately in a binary form that needs to be downloaded to the device.
> > This patch adds support to download this so-called CLM blob file. It
> > uses the same naming scheme as the other firmware files with extension
> > of .clm_blob.
> 
> What if the file does not exist, what happens then? I assume that the
> file is optional but the commit log should document that.

Yes, the CLM blob file is optional. If the file does not exist, it will
not affect the driver loading. The download process will be bypassed.

I will add this info to the commit meessage and resend a v2.

Regards,
Chung-Hsien

> 
> -- 
> Kalle Valo
