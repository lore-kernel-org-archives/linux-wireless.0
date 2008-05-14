Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:26978 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYENElJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 00:41:09 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1041458ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 21:41:05 -0700 (PDT)
Message-ID: <c785bba30805132141l62bef2d7n4d78a95510ed6a3d@mail.gmail.com> (sfid-20080514_064113_095634_621E4431)
Date: Tue, 13 May 2008 21:41:04 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: newbie rtl8187 question
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1210737929.2721.19.camel@rd>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c785bba30805132014y56aafa7bi8788503f67a7c809@mail.gmail.com>
	 <1210736718.2721.4.camel@rd>
	 <c785bba30805132050y51cc3031uae718bc74ade96@mail.gmail.com>
	 <1210737929.2721.19.camel@rd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks,

That worked! I unplugged my ethernet cable, and I'm sending this via
the wireless adapter.

If I can get some other patches on this same tree I can test the
driver on an arm9 processor (Atmel AT91RM9200). I'll let you know.

Any idea when those patches will find there way to the main line kernel?

thanks,
Paul

On Tue, May 13, 2008 at 9:05 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Tue, 2008-05-13 at 20:50 -0700, Paul Thomas wrote:
>  [private e-mail not quoted]
>
>  You can apply patches with patch or with StGIT.  If you haven't used
>  StGIT before, run "stg init" in the top source directory of the kernel.
>
>  stg import -n rtl8187b -u 'https://bugzilla.redhat.com/attachment.cgi?id=304231'
>  stg import -n rtl8187b-fix -u 'https://bugzilla.redhat.com/attachment.cgi?id=305203'
>
>  There will be some warnings about whitespace from StGIT, but the driver
>  compiles fine, and even sparse doesn't report any warnings.  I'm away
>  from the adapter, but I assume it would work.
>
>  P.S. Please don't take the discussion private.  Others may be interested
>  in it.
>
>  --
>  Regards,
>  Pavel Roskin
>
