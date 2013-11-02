Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41667 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3KBTNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Nov 2013 15:13:36 -0400
Received: by mail-wi0-f177.google.com with SMTP id f4so2301428wiw.16
        for <linux-wireless@vger.kernel.org>; Sat, 02 Nov 2013 12:13:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMP44s384vOcMc4vE82gAdVf37YUZfegmPHUSeobPO=gK6ErAw@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
 <526E20EA.9090203@rempel-privat.de> <CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
 <CABPxzY+xJ7kst-sYwP8RJwMO_zkNYWKaYy=_LS7WQfuxquK24w@mail.gmail.com>
 <CAMP44s0087jYz5AiEaEzwt7GqH9ed8PWE1CmvMPr4Dqn3yE6rA@mail.gmail.com>
 <CABPxzYLwwyFCFw1pEt0v9Xw4kcue1C_RZx0RbTbMrUw=+MWvgQ@mail.gmail.com>
 <CAMP44s0svc2MRKCrZXS5ZYRZNPoomQkcKHdC2m2BGy7di+TCyA@mail.gmail.com>
 <CABPxzYL-Gzbzoc_ui+qUQ6uzoKp=Yq7yLWZvc7PoEjiH3dFczg@mail.gmail.com>
 <CAMP44s3uRF=jNn5ZHZ=QOcvuMoXxsfkxU=VOq3K02Q0qOspEdA@mail.gmail.com>
 <CABPxzYJbNjAwymwUq0pN=YyuCBGy2qz_BKafatHTWK+yH8PbkA@mail.gmail.com>
 <CAMP44s1NOS2p9pKeMLhR7616CzHeHJVJEzcF1tP6tsKfcPhSOQ@mail.gmail.com>
 <CABPxzY+RL+ikbSff3a7qb20ExxcSTx6U2xcL5CFr-BgVSOr61A@mail.gmail.com> <CAMP44s384vOcMc4vE82gAdVf37YUZfegmPHUSeobPO=gK6ErAw@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 3 Nov 2013 00:43:14 +0530
Message-ID: <CABPxzYLDHP5gyeTL8HR=6uJDLptaUGEnNGSFLMkxKqi-JaBVYQ@mail.gmail.com> (sfid-20131102_201339_587318_B50C7620)
Subject: Re: I always need a miracle to connect with iwlwifi
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 2, 2013 at 10:36 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> Sorry for the crappy format (laptop is stuck).
>
> If the problem is the firmware why does it start working when I
> restart the router?

I was referring FW on iwlwifi, not the AP's. May be restarting the router
triggered some kind of event like Beacon Loss which might have
helped the STA to connect. Just guessing.

> Plus, I should be seeing this problem with other APs.
> And what could Windows be doing differently that doesn't exhibit this problem?

Without knowing the root cause it tough to comment these questions :-)
