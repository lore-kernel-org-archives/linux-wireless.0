Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:37335 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0LMKUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 05:20:50 -0500
Received: by fxm18 with SMTP id 18so6053424fxm.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 02:20:49 -0800 (PST)
Message-ID: <4D05F37E.4080806@googlemail.com>
Date: Mon, 13 Dec 2010 11:20:46 +0100
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Cannot set regdomain
References: <4D0384B3.8020702@googlemail.com>
In-Reply-To: <4D0384B3.8020702@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry folks! Absolutely my fault, since I did not install crda. I must
have forgotten it.

Sorry for bothering,
Dennis

Dennis Borgmann schrieb:
> Hello linux-wireless list!
>
> I tried the IRC, but there was no answer, so I try the mailing-list.
>
> I want to change my regdomain issuing this command:
>
> iw reg set DE
>
> But I get no change in regdomain, which I can observe using
>
> iw reg get
>
> which always shows me, I am in domain "00". If I start udevadm like this:
>
> udevadm monitor --environment kernel
>
> there is no output while issueing any of the commands shown above. I am
> using these commands with respect to this webpage-documentation:
>
> http://wireless.kernel.org/en/developers/Regulatory/CRDA
>
> Could anyone please tell me, why I cannot set the regdomain? I did
> follow the steps presented at
>
> http://acx100.erley.org/stable.html
>
> Kind regards,
> Dennis
>   

