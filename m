Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38644 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbcIGK7L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 06:59:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mwifiex: handle edmac vendor command
References: <1461945483-3239-1-git-send-email-akarwar@marvell.com>
        <cbd542a552db4d368a5b402307976494@SC-EXCH04.marvell.com>
        <87zirg8qxo.fsf@kamboji.qca.qualcomm.com>
        <e2b7d7d9aef1488a97eb7ec44b4c46af@SC-EXCH04.marvell.com>
        <87poon1xka.fsf@kamboji.qca.qualcomm.com>
        <0fa2b5d5e09f4396a9c273c3c8dfc3db@SC-EXCH04.marvell.com>
        <87d1km1hb6.fsf@kamboji.qca.qualcomm.com>
        <f827ba80b79646fd8711e1a00c2b8394@SC-EXCH04.marvell.com>
Date: Wed, 07 Sep 2016 13:59:06 +0300
In-Reply-To: <f827ba80b79646fd8711e1a00c2b8394@SC-EXCH04.marvell.com>
        (Amitkumar Karwar's message of "Wed, 7 Sep 2016 10:12:35 +0000")
Message-ID: <87fupcx9fp.fsf@kamboji.qca.qualcomm.com> (sfid-20160907_125927_914860_787D16AB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

>> > There is something called energy detect mode. Chip can detect non-WiFi
>> > radio signal also and monitor it for specified time before
>> > transmitting frames. As per ETSI specification, enabling this mode is
>> > mandatory for some countries for certain frequencies.
>> 
>> To me this looks this is something which can be generic, not a driver
>> specific interface. And why can't regulatory code enable this
>> automatically, without any user involvement? It already knows what
>> country we are in.
>
> Got it. I will check if we can make this as generic as you mentioned
> and explore the option.

Thanks. Please let us know how it goes.

-- 
Kalle Valo
