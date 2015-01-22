Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:55760 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbbAVOBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 09:01:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] bcma: clean bus initialization code
References: <1421435929-21499-1-git-send-email-zajec5@gmail.com>
	<1421438379-26211-1-git-send-email-zajec5@gmail.com>
	<54BBFCE5.9050500@hauke-m.de>
Date: Thu, 22 Jan 2015 16:01:10 +0200
In-Reply-To: <54BBFCE5.9050500@hauke-m.de> (Hauke Mehrtens's message of "Sun,
	18 Jan 2015 19:35:17 +0100")
Message-ID: <87ppa6ncd5.fsf@kamboji.qca.qualcomm.com> (sfid-20150122_150119_907015_0923C043)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens <hauke@hauke-m.de> writes:

> On 01/16/2015 08:59 PM, Rafał Miłecki wrote:
>> This moves main bus init code to the main.c and renames old function to
>> make its purpose clear.
>> Thanks to this change we'll also be able to separate scanning from
>> registration (and support PCIe Gen 2 devices) in the future.
>> 
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

No need to change anything now, but I think that in cases like this you
should use Acked-by:

  "13) When to use Acked-by: and Cc:

  The Signed-off-by: tag indicates that the signer was involved in the
  development of the patch, or that he/she was in the patch's delivery
  path.

  If a person was not directly involved in the preparation or handling
  of a patch but wishes to signify and record their approval of it then
  they can arrange to have an Acked-by: line added to the patch's
  changelog.

  Acked-by: is often used by the maintainer of the affected code when
  that maintainer neither contributed to nor forwarded the patch."


-- 
Kalle Valo
