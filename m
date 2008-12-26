Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:7581 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYLZSv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 13:51:27 -0500
Received: by rn-out-0910.google.com with SMTP id k40so2642567rnd.17
        for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2008 10:51:25 -0800 (PST)
Message-ID: <fd38e5150812261051y29851b18sf5638c57e355d6f2@mail.gmail.com> (sfid-20081226_195129_757498_650DEE93)
Date: Sat, 27 Dec 2008 00:21:25 +0530
From: "rajith pr" <rajithpr@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: How to install Ath5 driver?
In-Reply-To: <1230245303.16253.8.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <fd38e5150812251125n62086e63y64584282fbe9dbe4@mail.gmail.com>
	 <1230245303.16253.8.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavel,

I intend to work on the ath5k driver only. Iam actually stuck with the
Enabling ath5k section of
http://wireless.kernel.org/en/users/Drivers/ath5k. May be a trivial
think but i dont have an option but ask :-)

Enabling ath5k section talks about some configuration but i dont know
where to configure these. Should i run some configuration tool and
follow the steps ??

Thanks in advance,

Regards,
Rajith.

On Fri, Dec 26, 2008 at 4:18 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Fri, 2008-12-26 at 02:25 +0700, rajith pr wrote:
>> Hi all,
>>
>> Iam a wireless LAN developer over 4 Yrs of experience. Have worked on
>> wireless LAN AP, Routers and switches.
>> Have a passion to work on linux but never had the chance to do so. So,
>> i though this would be the rite time to start working on it. WLAN
>> being something i have expertise in i would like to do some feature
>> development on madwifi drivers.
>
> MadWifi is not the same thing as ath5k.  If you want to work on MadWifi,
> please look at https://madwifi-project.org/ and write to
> madwifi-devel@lists.sourceforge.net if you have any questions.
>
>> After reading the developer notes from wiki i have been able to
>> download the sources. Now i want to build the sources, install the
>> driver and try it on wireless card.
>
> Please be specific want you read, what you downloaded (including the
> version) and what kind of problems you have with the code.
>
>> Can anyone guide me on this.
>
> It would be better if you follow the existing documentation and ask only
> about thing that are unclear or about problems that are not described in
> the documentation.  Asking for guidance is an "open-ended question".
> More details here:
>
> http://www.catb.org/~esr/faqs/smart-questions.html#explicit
>
> --
> Regards,
> Pavel Roskin
>
