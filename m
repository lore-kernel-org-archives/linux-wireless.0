Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:51804 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab3J1SnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 14:43:12 -0400
Received: by mail-lb0-f170.google.com with SMTP id u14so3270014lbd.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 11:43:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzY+xJ7kst-sYwP8RJwMO_zkNYWKaYy=_LS7WQfuxquK24w@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
	<526E20EA.9090203@rempel-privat.de>
	<CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
	<CABPxzY+xJ7kst-sYwP8RJwMO_zkNYWKaYy=_LS7WQfuxquK24w@mail.gmail.com>
Date: Mon, 28 Oct 2013 12:43:10 -0600
Message-ID: <CAMP44s0087jYz5AiEaEzwt7GqH9ed8PWE1CmvMPr4Dqn3yE6rA@mail.gmail.com> (sfid-20131028_194318_743244_EAFF06D3)
Subject: Re: I always need a miracle to connect with iwlwifi
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 12:28 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Mon, Oct 28, 2013 at 11:30 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>
>> The authentication response does come back in both cases though, it's
>> just the acknowledgement that is missing. Unfortunately I cannot
>> figure out for which message it's the ack.
>>
>> Also, I notice the sequence number received from the router doesn't
>> seem to change. All the authentication requests received have the same
>> number (256). Another peculiar thing is that in the failed case the SN
>> we send starts with 0.
>>
>> I suppose since the authentication ack never arrives, the next steps
>> are never completed.
>>
>> Does that help?
> From the supplicant logs we have successfully received the
> authentication response
> and sent out the association request. So are you referring to not receiving ACK
> for association request??

No, from the capture there's no association request in the bad case,
only in the good one.

> It would be nice to get the capture without any filters?

http://people.freedesktop.org/~felipec/wpa/wpa-bad.pcapng
http://people.freedesktop.org/~felipec/wpa/wpa-good.pcapng

-- 
Felipe Contreras
