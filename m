Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60172 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2IZULQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 16:11:16 -0400
Received: by obbuo13 with SMTP id uo13so1011469obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 13:11:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55A363C1E44B4755BD470FD0A00C5D53@Connectone.local>
References: <1346014505-7554-1-git-send-email-ordex@autistici.org>
	<1346014505-7554-2-git-send-email-ordex@autistici.org>
	<CAGRGNgUoNnuh_23qzULJyJcvMUgNpUxFnZjaAcGj26_jrTHdeA@mail.gmail.com>
	<1346045881.3746.0.camel@jlt4.sipsolutions.net>
	<CAGRGNgXy3t5TJqY=VwKjPEH=K4XKR_Dm5qVKkmYxStYoAP3fvQ@mail.gmail.com>
	<55A363C1E44B4755BD470FD0A00C5D53@Connectone.local>
Date: Wed, 26 Sep 2012 13:11:15 -0700
Message-ID: <CAJ-Vmomm_2VEyk9O1NhwhtoZRrJvYGTge1myi5QQQoZcvZRg1A@mail.gmail.com> (sfid-20120926_221119_978395_16963E2F)
Subject: Re: ath9k_htc: number of VIFs limitation
From: Adrian Chadd <adrian@freebsd.org>
To: Daniel Doron <danield@connectone.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 August 2012 00:16, Daniel Doron <danield@connectone.com> wrote:
> Hi,
>
> Newbie question: what is the reason for the limitation of the number of VIFs
> and their combination that is allowed? Is this a s/w limitation or h/w
> limitation?

Short answer: yes.

Long answer: there's limited RAM resources on the USB CPU and there's
some per-STA state being kept. Sujith knows the details better, I've
stayed out of ath9k_htc internals to date. :)



Adrian
