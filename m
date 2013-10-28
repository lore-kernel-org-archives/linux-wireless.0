Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:44101 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3J1VcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 17:32:15 -0400
Received: by mail-lb0-f178.google.com with SMTP id o14so3296287lbi.23
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 14:32:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYL-Gzbzoc_ui+qUQ6uzoKp=Yq7yLWZvc7PoEjiH3dFczg@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
	<526E20EA.9090203@rempel-privat.de>
	<CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
	<CABPxzY+xJ7kst-sYwP8RJwMO_zkNYWKaYy=_LS7WQfuxquK24w@mail.gmail.com>
	<CAMP44s0087jYz5AiEaEzwt7GqH9ed8PWE1CmvMPr4Dqn3yE6rA@mail.gmail.com>
	<CABPxzYLwwyFCFw1pEt0v9Xw4kcue1C_RZx0RbTbMrUw=+MWvgQ@mail.gmail.com>
	<CAMP44s0svc2MRKCrZXS5ZYRZNPoomQkcKHdC2m2BGy7di+TCyA@mail.gmail.com>
	<CABPxzYL-Gzbzoc_ui+qUQ6uzoKp=Yq7yLWZvc7PoEjiH3dFczg@mail.gmail.com>
Date: Mon, 28 Oct 2013 15:32:13 -0600
Message-ID: <CAMP44s3uRF=jNn5ZHZ=QOcvuMoXxsfkxU=VOq3K02Q0qOspEdA@mail.gmail.com> (sfid-20131028_223218_586479_0E096CCC)
Subject: Re: I always need a miracle to connect with iwlwifi
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 2:44 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Tue, Oct 29, 2013 at 1:36 AM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> On Mon, Oct 28, 2013 at 1:27 PM, Krishna Chaitanya
>> <chaitanya.mgit@gmail.com> wrote:
>
>>> From the logs we can see that we have received authentication response,
>>> so the association request is getting dropped somewhere? We might
>>> need the mac80211 and iwlwifi trace-cmd logs to check for the drop.
>>>
>>> http://wireless.kernel.org/en/developers/Documentation/mac80211/tracing
>>
>> There you go:
>> http://people.freedesktop.org/~felipec/wpa/trace.dat.xz
>>
> Hmm.."trace-cmd report -i trace.dat" returned lots of errors, i have even
> tried with the trace-cmd from git (ubuntu). Did it worked fro you?

Yes, but maybe I overrode the file. I've pushed a new one again. The
sha-1 is 36c260d8d8c171a24eb1aa7b2ea736b06c9b55b7.

-- 
Felipe Contreras
