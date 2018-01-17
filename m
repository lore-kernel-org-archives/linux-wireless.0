Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:44828 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbeAQKMA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 05:12:00 -0500
MIME-Version: 1.0
In-Reply-To: <1384d3ee94eb48f29e85161d9a8fa136@codeaurora.org>
References: <1513270393-919-7-git-send-email-qca_merez@qca.qualcomm.com>
 <20180109080707.B05B66081B@smtp.codeaurora.org> <1384d3ee94eb48f29e85161d9a8fa136@codeaurora.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 17 Jan 2018 21:11:38 +1100
Message-ID: <CAGRGNgUmtZcW=xewDPCathwCUMXjqXk_qTPcOjb9+VCOm=nskg@mail.gmail.com> (sfid-20180117_111205_017159_F9D90998)
Subject: Re: [v2,6/9] wil6210: add support for headroom configuration
To: merez@codeaurora.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Lazar Alexei <QCA_ailizaro@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        wil6210@qca.qualcomm.com, linux-wireless-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Maya,

On Tue, Jan 16, 2018 at 12:18 AM,  <merez@codeaurora.org> wrote:
> On 2018-01-09 10:07, Kalle Valo wrote:
>>
>> Maya Erez <qca_merez@qca.qualcomm.com> wrote:
>>
>>> Add module parameter for configuring the headroom size
>>> in the skb allocation.
>>>
>>> Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
>>> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
>>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>
>>
>> Why?
>
>
> Some platforms have specific requirements on packet alignment.
> I will upload an update of the commit text in the next set of 11ad patches.

Is this something the platform can tell you or something you can store
in an array by platform name? (and use the maximum size if we don't
know)

Alternatively, would it waste too much RAM to just set this to the
maximum size and have done?

I feel that allowing the user to set it will be problematic.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
