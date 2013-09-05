Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:35605 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab3IEE54 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 00:57:56 -0400
Received: by mail-we0-f178.google.com with SMTP id u57so167063wes.23
        for <linux-wireless@vger.kernel.org>; Wed, 04 Sep 2013 21:57:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871u53swie.fsf@kamboji.qca.qualcomm.com>
References: <1376939466-8282-1-git-send-email-kvalo@qca.qualcomm.com>
 <1376939466-8282-2-git-send-email-kvalo@qca.qualcomm.com> <CAB=NE6UCmO4QbFjtav8xPDAoebpTqDNwz_qQxg1TQ8cKGcbFGg@mail.gmail.com>
 <871u53swie.fsf@kamboji.qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 5 Sep 2013 14:57:35 +1000
Message-ID: <CAGRGNgXhk6RDMKxtz-9JUW2K76rtwH-W8-gvoTxr0616G-e2rQ@mail.gmail.com> (sfid-20130905_065758_896118_A3C80045)
Subject: Re: [PATCH 2/2] qca-swiss-army-knife: add ath10k trace-cmd plugin
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Thu, Sep 5, 2013 at 2:49 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> writes:
>
>> On Mon, Aug 19, 2013 at 12:11 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> This one's a skeleton as well.
>>>
>>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>>
>> Applied both and pushed, thanks!
>
> Thanks.
>
>> I just removed 3 trailing spaces on the 2 patches. One had two
>> trailing spaces, the last patch had one.
>
> Oh, sorry about that. Any ideas how I could check for those myself?

If you have coloured diff output enabled in git (color.diff = true)
then they and other whitespace errors are highlighted in red whenever
you do diffs.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
