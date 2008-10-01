Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:16174 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYJAJQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 05:16:30 -0400
Received: by ti-out-0910.google.com with SMTP id b6so179996tic.23
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 02:16:28 -0700 (PDT)
Message-ID: <e001a6370810010216w3d1d15bdu124ab1f8b4b19e5c@mail.gmail.com> (sfid-20081001_111634_528466_A80365B3)
Date: Wed, 1 Oct 2008 14:46:28 +0530
From: "Anadi Mishra" <reachanadi@gmail.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: Problem with Libertas USB8388 WLAN card firmware
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200809301307.59344.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e001a6370809150258t10873497jcf04e68005db566b@mail.gmail.com>
	 <200809301018.31678.hs4233@mail.mn-solutions.de>
	 <e001a6370809300234j7f84a9f0j50213e9912dd5c08@mail.gmail.com>
	 <200809301307.59344.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 30, 2008 at 4:37 PM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
>> regarding rest of the things u pointed out, its all greek to
>> me (I am noob). But could u plz tell me from where can i get
>> the firmware details of the card
>> USB8388??
>
> I don't think that you have a firmware problem.
>
> Probably some compiler / alignment issue.
>
> Result codes from the firmware are 16 bit, but 0x160000 doesn't
> fit into an 16 bits. So you need to search why your
> compiler/hardware creates 0x160000 out of two transferred bytes.

  Sorry for the trouble but can u give some hint how to go about it?

Thanks a lot.

> But *ANY* firmware for the 8388 chips returns the result as 16
> bits, that is two bytes. If you get bogus / hosed result, you
> have a problem there. And using a different firmware won't help
> you there. There is an underlying problem that you need to solve
> first.
>
>
> BTW: you can get the firmware specification via this driver
> portal: http://wireless.kernel.org/en/users/Drivers/libertas
>



-- 
Thanks and Regards,
Anadi Mishra,
Mumbai,
9987388960.
