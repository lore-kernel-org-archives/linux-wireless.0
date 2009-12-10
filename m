Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:37217 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZLJObP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 09:31:15 -0500
Received: by iwn1 with SMTP id 1so5383616iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2009 06:31:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ein30vt4.fsf@purkki.valot.fi>
References: <20091209211054.GB32058@tuxdriver.com> <87ljhb0x0h.fsf@purkki.valot.fi>
	<20091210134733.GC11112@tuxdriver.com> <87ein30vt4.fsf@purkki.valot.fi>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 10 Dec 2009 06:31:02 -0800
Message-ID: <43e72e890912100631if1c17b2l597168813db4a19c@mail.gmail.com>
Subject: Re: Revised wireless tree management practices
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 10, 2009 at 6:04 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:
>
>> I still see value in a tree that has a reasonably stable base and
>> contains both wireless fixes and wireless features.
>
> I agree, it makes things a lot easier.
>
>> So, I think wireless-testing remains as the focal point for wireless
>> LAN testing and development. I'll just be getting patches there in a
>> slightly different process.
>
> Sounds very good. So I'll continue using wireless-testing. Thanks.

But we use wireless-next as base though if we want to send you pull
requests, ay?

  Luis
