Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60320 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbbB0QbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 11:31:03 -0500
Message-ID: <1425054660.1960.7.camel@sipsolutions.net> (sfid-20150227_173110_009881_7362BE8C)
Subject: Re: Intel Wireless 7260 - Possible bug within iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?=D0=91=D0=BE=D1=80=D0=B8=D1=81=D0=BB=D0=B0=D0=B2_?=
	 =?UTF-8?Q?=D0=A1=D1=8A=D0=B1=D0=B5=D0=B2?=
	<borislavsabev@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 27 Feb 2015 17:31:00 +0100
In-Reply-To: <CA+uMeVcwpfOfQ=TnQA5omYga5Qu1bynNYz1gAQbcR4VqpFcXXg@mail.gmail.com> (sfid-20150227_171142_538428_5980AB84)
References: <CA+uMeVeu0y892+HPCNK5zbuk48WTawaue9p5j690D9n77yzw1w@mail.gmail.com>
	 <CA+uMeVct4LSHw9HsxFm1DCdEPDr81_SpkHFeyQptd2eR1+1XSg@mail.gmail.com>
	 <CA+uMeVcwpfOfQ=TnQA5omYga5Qu1bynNYz1gAQbcR4VqpFcXXg@mail.gmail.com>
	 (sfid-20150227_171142_538428_5980AB84)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-02-27 at 18:11 +0200, Борислав Събев wrote:

> The problem is that If our WiFi goes down (or we need to restart the
> router) after the router is back up the connection could not be
> established again.

I'm not sure I understand - the below has nothing to do with the router?

> In the dmesg line: "[  167.863245] iwlwifi 0000:02:00.0: RF_KILL bit
> toggled to disable radio."      is produced when we try to stop/start
> the adapter via its hardware button or the button in NetworkManager.

That's pretty normal. Does it also show "to enable radio"? If you're
saying it just gets stuck in rfkill-disabled state then this is much
more likely a platform than iwlwifi issue, perhaps in the ACPI or other
platform rfkill drivers.

> Hope this helps to solve the issue for everyone.
> Again I have 4 machines with this issue so I can also test different
> stuff on Debian 8 Jessie & Ubuntu 14.04!

I have no idea what you'd want to test :)

johannes

