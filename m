Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:49740 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3J1LA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 07:00:59 -0400
Received: by mail-we0-f177.google.com with SMTP id x55so6170006wes.8
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 04:00:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMP44s2G63ptScncpPE0ercLY0fT7q0RAvSO6ROyMxm_jLRYXA@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
 <526E20EA.9090203@rempel-privat.de> <CABPxzYJ8HpdwOYZ4hA40m3MOo_r7CwktzzpM9g6SLdPf6Rkqjg@mail.gmail.com>
 <CAMP44s2G63ptScncpPE0ercLY0fT7q0RAvSO6ROyMxm_jLRYXA@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 28 Oct 2013 16:30:38 +0530
Message-ID: <CABPxzYLUG-X=p5z4fJusH63EvtuOy=EKfeQPScHDwGDpAJoFYg@mail.gmail.com> (sfid-20131028_120104_099135_6780DBF1)
Subject: Re: I always need a miracle to connect with iwlwifi
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 3:07 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
>> Looks like there is "maximum clients" feature is enabled in the AP, most AP's
>> send deauth for Auth/Assoc Request but some AP's silently discard the
>> Assoc Request.
>>
>> That explains why it works after reboot/adhoc mode. Try increasing the
>> number if thats the case.
>
> Then why am I able to connect from my phone, other machines, and in
> this machine with Windows 7?
>
So lets say "max clients=5" and first all of your devices except the
linux connec
to the AP, then they have no issues connecting. Now if the linux is
the 6th device
then it might have trouble connecting to the AP?? Its possible.
