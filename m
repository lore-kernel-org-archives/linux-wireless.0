Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36648 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdBFKIO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 05:08:14 -0500
Received: by mail-io0-f179.google.com with SMTP id j13so61835602iod.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2017 02:08:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170206100100.GA5905@jouni.qca.qualcomm.com>
References: <1486308208-3252-1-git-send-email-ard.biesheuvel@linaro.org> <20170206100100.GA5905@jouni.qca.qualcomm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 6 Feb 2017 10:08:12 +0000
Message-ID: <CAKv+Gu9rrk7VosUg24nMqU=gyC_0D7UA=39UsoCgJ1fmh0yTdQ@mail.gmail.com> (sfid-20170206_110821_009892_1183BCF0)
Subject: Re: [PATCH v2 0/2] mac80211: use crypto shash for AES cmac
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 February 2017 at 10:01, Malinen, Jouni <jouni@qca.qualcomm.com> wrote:
> On Sun, Feb 05, 2017 at 03:23:26PM +0000, Ard Biesheuvel wrote:
>> NOTE: Jouni has been so kind to test patch #2, and confirmed that it is working.
>>       I have not tested patch #1 myself, mainly because the test methodology
>>       requires downloading Ubuntu installer images, and I am currently on a
>>       metered 3G connection (and will be for another couple of weeks)
>
> These v2 patches pass the test cases as well.
>

Thanks!

> (And you don't really need Ubuntu to run the hwsim test cases; any
> reasonably recent distribution that is capable of running kvm should
> work.)
>

Well, now that you have done my testing for me, I am not sure I will
get around to trying the VM.

Thanks,
Ard.
