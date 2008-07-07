Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:52172 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbYGGVJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 17:09:23 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1465149waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 14:09:23 -0700 (PDT)
Message-ID: <cb0375e10807071409r40e29c71w5c2bf7540c73dcde@mail.gmail.com> (sfid-20080707_230929_374020_E3BC7C76)
Date: Mon, 7 Jul 2008 17:09:23 -0400
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: Question on rfkill double block
Cc: thomasw@gmail.com, zhu.yi@intel.com,
	linux-wireless@vger.kernel.org, dcbw@redhat.com
In-Reply-To: <cb0375e10807071218w3dacef45kaaaba102ecc03c59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214982208.14590.473.camel@debian.sh.intel.com>
	 <20080702193202.GA20410@khazad-dum.debian.net>
	 <1ba2fa240807051428i3f49f621i7b583bec58a02869@mail.gmail.com>
	 <20080706002037.GD21973@khazad-dum.debian.net>
	 <48719F2F.5060301@myrealbox.com>
	 <20080707165634.GA24815@khazad-dum.debian.net>
	 <cb0375e10807071147u5a8ce6bsd6193a2e11dac24@mail.gmail.com>
	 <cb0375e10807071218w3dacef45kaaaba102ecc03c59@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 7, 2008 at 3:18 PM, Andrew Lutomirski <luto@myrealbox.com> wrote:
> On Mon, Jul 7, 2008 at 2:47 PM, Andrew Lutomirski <luto@myrealbox.com> wrote:
>> On Mon, Jul 7, 2008 at 12:56 PM, Henrique de Moraes Holschuh
>> <hmh@hmh.eng.br> wrote:
>>> On Mon, 07 Jul 2008, Andy Lutomirski wrote:
>
> OK, got a "bug" for you.  I'm not sure whether it's a bug in rfkill,
> rfkill-input, iwlwifi, thinkpad-acpi, or the way they all interact.
>
> If I press the button on the keyboard (the icon makes it look like
> wifi), then bluetooth is toggled on and off and nothing happens to
> wlan rfkill.  This is fine with me.

Nevermind this part.  It was some leftover cruft in Ubuntu Hardy's acpid.

>
> But if I toggle bluetooth off (killed and therefore not present in the
> system per thinkpad-acpi), then block wlan with the switch, then
> unblock wlan with the switch, then bluetooth turns back on.  This only
> happens with rfkill-input loaded.  I hope this isn't the intended
> behavior.

This still happens with rfkill-input, though.

--Andy
