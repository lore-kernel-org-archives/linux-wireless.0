Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37959 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbbJTMVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 08:21:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-firmware@kernel.org>, <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/5] ath10k: QCA988X hw2.0: add board.bin
References: <1444905644-16296-1-git-send-email-kvalo@qca.qualcomm.com>
	<1445192636.31451.74.camel@decadent.org.uk>
Date: Tue, 20 Oct 2015 15:21:30 +0300
In-Reply-To: <1445192636.31451.74.camel@decadent.org.uk> (Ben Hutchings's
	message of "Sun, 18 Oct 2015 19:23:56 +0100")
Message-ID: <87fv15d92t.fsf@kamboji.qca.qualcomm.com> (sfid-20151020_142156_436690_B19ECFDC)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Hutchings <ben@decadent.org.uk> writes:

> On Thu, 2015-10-15 at 13:40 +0300, Kalle Valo wrote:
>> In commit 40d14143b787 ("ath10k: add firmware 10.2.4.45 as firmware-4.bin") I
>> forgot to commit board.bin file and that's why it was not included in the
>> commit even I had added an entry to WHENCE. Add that now.
>> 
>> At the same time also add Version field for firmware-4.bin.
>> 
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> [...]
>
> I've applied this and the following 4 patches.  However, I'm not
> entirely happy with copyright acknowledgements going into the
> notice_ath10k*.txt files which aren't referenced anywhere.  It would be
> easy for downstream distributors to miss that they should be packaged
> along with the firmware blobs they relate to.  Please can you combine
> these with the QCA licence file or add references to these files from
> WHENCE?

Combining with the license file is difficult as the notice.txt can be
different between firmware versions, but I can add a reference to
WHENCE. I guess you mean to add a new "File: " line for each .txt file?

-- 
Kalle Valo
