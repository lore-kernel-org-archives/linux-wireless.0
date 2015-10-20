Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54076 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbbJTM3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 08:29:31 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-firmware@kernel.org>, <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/5] ath10k: QCA988X hw2.0: add board.bin
References: <1444905644-16296-1-git-send-email-kvalo@qca.qualcomm.com>
	<1445192636.31451.74.camel@decadent.org.uk>
	<1445193116.31451.78.camel@decadent.org.uk>
Date: Tue, 20 Oct 2015 15:29:13 +0300
In-Reply-To: <1445193116.31451.78.camel@decadent.org.uk> (Ben Hutchings's
	message of "Sun, 18 Oct 2015 19:31:56 +0100")
Message-ID: <87bnbtd8py.fsf@kamboji.qca.qualcomm.com> (sfid-20151020_142935_032649_7B3848CA)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Hutchings <ben@decadent.org.uk> writes:

> On Sun, 2015-10-18 at 19:23 +0100, Ben Hutchings wrote:
>> On Thu, 2015-10-15 at 13:40 +0300, Kalle Valo wrote:
>> > In commit 40d14143b787 ("ath10k: add firmware 10.2.4.45 as firmware-4.bin") I
>> > forgot to commit board.bin file and that's why it was not included in the
>> > commit even I had added an entry to WHENCE. Add that now.
>> > 
>> > At the same time also add Version field for firmware-4.bin.
>> > 
>> > Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> [...]
>> 
>> I've applied this and the following 4 patches.  However, I'm not
>> entirely happy with copyright acknowledgements going into the
>> notice_ath10k*.txt files which aren't referenced anywhere.  It would be
>> easy for downstream distributors to miss that they should be packaged
>> along with the firmware blobs they relate to.  Please can you combine
>> these with the QCA licence file or add references to these files from
>> WHENCE?
>> 
>
> Also please make sure that all text files are encoded as UTF-8 (or
> ASCII).  A couple of the notices had quote characters which I
> eventually worked out to be GB2312-encoded.

Sorry about that, I'll check for that in the future.

-- 
Kalle Valo
