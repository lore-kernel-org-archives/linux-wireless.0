Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40381 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355Ab2BCV2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 16:28:09 -0500
Received: by obcva7 with SMTP id va7so4753130obc.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 13:28:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F2C4BB2.1070207@broadcom.com>
References: <CADGLRPncrRHRFUXHfUWM31d0THzuJx_2a=+aifcFR39jT7WpLA@mail.gmail.com>
	<4F2C4BB2.1070207@broadcom.com>
Date: Fri, 3 Feb 2012 16:28:08 -0500
Message-ID: <CADGLRPn93_vjD00sGpof5dSg3Vpyf3iOREh+mU8S9tZDDj5=rg@mail.gmail.com> (sfid-20120203_222818_917888_07D85074)
Subject: Re: Broadcom brcm80211 monitor mode
From: Daniel Smith <viscous.liquid@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Arend,

On Fri, Feb 3, 2012 at 4:03 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 02/03/2012 09:01 PM, Daniel Smith wrote:
>> Hi
>>
>> I see on the "To be done list" for both the fullmac and softmac chips
>> is to add support for monitor mode. I was wondering how realistic is
>> that task. If it is definitely going to occur, any idea what it will
>> support, e.g. capturing management frames. Also any kind of hint what
>> kind of time frame are you looking at? Any info would be greatly
>> appreciated.
>>
>> V/r,
>> Daniel Smith
>>
>
> For brcmsmac it has already been done just using the radiotap
> functionality. I did not implement it, but I think this functionality is
> provided by cfg80211. Not sure if that is sufficient info.
>
> Gr. AvS
>

Thanks for the quick response and that is excellent to hear! Is there
any word on the fullmac side? I am actually interested in both as I
will be dealing with both standard and mobile devices. Due to the
popularity of your chips, it would be great if I could add Broadcom to
my list of viable chips.

Thanks!
dps
