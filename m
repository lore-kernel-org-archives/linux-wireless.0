Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:64303 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaAWMKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 07:10:25 -0500
Received: by mail-bk0-f51.google.com with SMTP id w10so316078bkz.38
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 04:10:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ha8u6h9v.fsf@kamboji.qca.qualcomm.com>
References: <1390473506-15677-1-git-send-email-michal.kazior@tieto.com>
	<87ha8u6h9v.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 23 Jan 2014 13:10:22 +0100
Message-ID: <CA+BoTQkyQBnWomTbCVqySXvXfUR1Un=4dHJuCZE3ATc9m_bJow@mail.gmail.com> (sfid-20140123_131027_941774_EE72C3DF)
Subject: Re: [PATCH 0/2] ath10k: add CSA support
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 January 2014 12:59, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This is a refactored and rewritten AP CSA patch
>> split into 2. As a bonus this fixes STA CSA as
>> well.
>>
>>
>> Michal Kazior (2):
>>   ath10k: implement channel switching
>>   ath10k: implement AP CSA
>
> Oddly enough only the cover letter was delivered to ath10k list, no idea
> what happened to the patches. But I can get the patches from
> linux-wireless lists.
>
> But do these patches depend to any mac80211 or cfg80211 patches. Or is
> it safe to take these to my ath-next branch?

It's safe take them. They don't have any strange dependencies.


Michał
