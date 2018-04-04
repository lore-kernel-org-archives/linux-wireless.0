Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54702 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbeDDGLk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 02:11:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Steve deRosier <derosier@gmail.com>
Cc: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes\@sipsolutions.net" <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Amarnath Hullur Subramanyam <amarnath@qti.qualcomm.com>,
        Rajesh Chauhan <rajeshc@qti.qualcomm.com>
Subject: Re: Wi-Fi Disconnection on Suspend for no wowlan triggers
References: <0663e93cc5ca45e6b7191760414b1189@aphydexm01f.ap.qualcomm.com>
        <CALLGbRJgAtOdZ1puzfgpWxc_ZrDVmWXtmFrBu=-gA0C++WrLoA@mail.gmail.com>
Date: Wed, 04 Apr 2018 09:11:34 +0300
In-Reply-To: <CALLGbRJgAtOdZ1puzfgpWxc_ZrDVmWXtmFrBu=-gA0C++WrLoA@mail.gmail.com>
        (Steve deRosier's message of "Tue, 3 Apr 2018 09:55:43 -0700")
Message-ID: <874lkrmrft.fsf@purkki.adurom.net> (sfid-20180404_081144_112246_D4346C2B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve deRosier <derosier@gmail.com> writes:

> On Tue, Apr 3, 2018 at 5:39 AM, Sunil Dutt Undekari
> <usdutt@qti.qualcomm.com> wrote:
>> Hi All ,
>>
>> I would like to discuss on the commit
>> 8125696991194aacb1173b6e8196d19098b44e17 (cfg80211/mac80211:
>> disconnect on suspend) which triggers the STA disconnection on
>> suspend if no wowlan triggers are registered.
>
> This commit went in over five years ago. Sometime around v3.9

Yup, v3.10-rc2 was the first release.

-- 
Kalle Valo
