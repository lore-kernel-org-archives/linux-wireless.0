Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35310 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbcCRDc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 23:32:28 -0400
Received: by mail-oi0-f50.google.com with SMTP id w20so23366852oia.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 20:32:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56EB6A10.5030900@lwfinger.net>
References: <cover.1458262312.git.julian.calaby@gmail.com> <bc393706a087bf9746d7e91963e11819a854c4f7.1458262312.git.julian.calaby@gmail.com>
 <56EB6A10.5030900@lwfinger.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 18 Mar 2016 14:32:07 +1100
Message-ID: <CAGRGNgU9kQvkq1j1h8wtbny=28jN7UJoBK=1F1eS03TnRkGg-g@mail.gmail.com> (sfid-20160318_043231_717066_5C3B0DDA)
Subject: Re: [PATCH MOREWORK 16/19] rtlwifi: Implement 'rtl_addr_delay()' with
 a switch statement
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Byeoungwook Kim <quddnr145@gmail.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Sara Sharon <sarasharon1@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luis Felipe Dominguez Vega <lfdominguez@nauta.cu>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Fri, Mar 18, 2016 at 1:38 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 03/17/2016 09:28 PM, Julian Calaby wrote:
>>
>> From: Byeoungwook Kim <quddnr145@gmail.com>
>>
>> Doing it this way improves readability.
>>
>> Signed-off-by: Byeoungwook Kim <quddnr145@gmail.com>
>> [Rewrote commit message]
>> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
>>
>> ---
>>
>> ... or does it.
>>
>> Honesltly, this is only in this list as Byeoungwook asked about it and I
>> can see _some_ sort of reason why it exists.
>>
>> Larry, if you don't like this, please NACK it and we'll never speak of it
>> again.
>>
>> Thanks,
>>
>> Julian Calaby
>> ---
>>   drivers/net/wireless/realtek/rtlwifi/core.c | 20 ++++++++++++++------
>>   1 file changed, 14 insertions(+), 6 deletions(-)
>
>
> I thought I had already NACKed it, but just in case:
>
> NACK.

Consider it dropped.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
