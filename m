Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:46020 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751265AbdGQJqF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 05:46:05 -0400
Subject: Re: RFC: Broadcom fmac wireless driver cleanup
To: James Hughes <james.hughes@raspberrypi.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
 <CACna6rxQNqdpuiq2mF3EJQ694AHa74tVex06vp53kqjrwoNkog@mail.gmail.com>
 <CAE_XsMLVjT1kGmQBciADQwHKS+AgytzxePyQrYnGQQqanFj9jw@mail.gmail.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <0c29a7c4-cd74-0ac1-fca9-b8e9dba656ea@mnementh.co.uk> (sfid-20170717_114609_388908_0F0590F4)
Date: Mon, 17 Jul 2017 10:45:56 +0100
MIME-Version: 1.0
In-Reply-To: <CAE_XsMLVjT1kGmQBciADQwHKS+AgytzxePyQrYnGQQqanFj9jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/17 10:13, James Hughes wrote:

> As someone who is interested in any bug fixes to this driver (Device
> is used on Raspberry Pi3/0W and we have a number of issues reported
> which we are actively investigating), it would be very useful to more
> clearly split out any actual fixes vs simply tidying up (Yes, I agree
> the driver is mostly incomprehensible).

I don't think there are any actual *fixes* in this RFC series. Its all
cleanup.

The only issue I highlighted in my covering email - the patch titled
"HACK" was the only issue I uncovered thus far in that code. I dont know
the correct solution, although I can *guess* it, which is not good
enough, IMO.

If no-one has the docs for this chip, thats a bad state of affairs. Is
there anything circulating?

> Perhaps asking the
> list/maintainers for comments on any located issues/bugs fixes would
> be a useful starting point,

Thats *literally* what RFC means, is it not?

> along with ensuring the description gives a good explanation of what
> the suspect issue is.

Yes, absolutely - for a fully signed off series, or a particularly
complex bit of code, sure.

I think each of these patches is easily reviewable. None of them are
complex, just huge.

As yet, I have *zero* idea that the maintainers are interested in taking
the driver in the direction I'm going. It looks a LOT like a typical
corporate code-dump, and unless I'm convinced that sending carefully
polished patches is worth it, I don't see why I should put the effort in.

Trust goes both ways in this process. Give me a sign that I should carry
on with this work. If its got no hope of ever going upstream, all I'm
doing is wasting time.

-Ian
