Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5358 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbbJTDuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 23:50:05 -0400
From: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 0/2 v2] ath10k: print firwmare stats specific to firmware
 version
Date: Tue, 20 Oct 2015 03:49:54 +0000
Message-ID: <cd133c47903b4f159461914b25365a8c@aphydexm01f.ap.qualcomm.com> (sfid-20151020_055011_164364_65ED7AE1)
References: <1444812751-11103-1-git-send-email-c_traja@qti.qualcomm.com>
 <87vba2gbrz.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87vba2gbrz.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>>
>> Currently printing fw stats in ath10k is common to all firmware versions.
>> Printing all the stats might lead to confusion because some of the 
>> stats are firmware specific and when printed will have 0's.
>> Below patchset prints firmware stats specific to firmware.
>>
>> v2:
>>         > All the filtered functions moved to wmi.c
>>         > Added firmware stats support for 10.4 firmware.
>>
>> Manikanta (2):
>>   ath10k: Make fw stats prints specific to firmware version

>Applied this patch.

>>   ath10k: add fw_stats support to 10.4 firmware

>Dropped this patch due to the bug I saw. Please resend once you have fixed that.

Ok kalle. I will send the patch once the issue fixed.

___
Tamizh.
