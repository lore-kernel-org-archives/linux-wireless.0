Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48850 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3J1PyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 11:54:05 -0400
Received: by mail-lb0-f177.google.com with SMTP id u14so2940011lbd.8
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 08:54:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYLUG-X=p5z4fJusH63EvtuOy=EKfeQPScHDwGDpAJoFYg@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
	<526E20EA.9090203@rempel-privat.de>
	<CABPxzYJ8HpdwOYZ4hA40m3MOo_r7CwktzzpM9g6SLdPf6Rkqjg@mail.gmail.com>
	<CAMP44s2G63ptScncpPE0ercLY0fT7q0RAvSO6ROyMxm_jLRYXA@mail.gmail.com>
	<CABPxzYLUG-X=p5z4fJusH63EvtuOy=EKfeQPScHDwGDpAJoFYg@mail.gmail.com>
Date: Mon, 28 Oct 2013 09:54:03 -0600
Message-ID: <CAMP44s0HUgitdq0x56Qk+23yhaRc2Ly-JWbeHL9T6D4D=z74Gw@mail.gmail.com> (sfid-20131028_165409_744878_7A2DA506)
Subject: Re: I always need a miracle to connect with iwlwifi
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 5:00 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Mon, Oct 28, 2013 at 3:07 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:

>> Then why am I able to connect from my phone, other machines, and in
>> this machine with Windows 7?
>>
> So lets say "max clients=5" and first all of your devices except the
> linux connec
> to the AP, then they have no issues connecting. Now if the linux is
> the 6th device
> then it might have trouble connecting to the AP?? Its possible.

Yeah, but if max-clients = 5, and clients = 5, nothing would change
when I reboot to Windows and it works. Also, if it's working on Linux,
I reboot my machine, and then I cannot connect again. Plus, I
disconnect my phone, I try to connect in Linux, it keeps failing, I
connect my phone, and my phone works.

I don't think this theory matches the evidence at all.

-- 
Felipe Contreras
