Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55647 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab0LUTio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 14:38:44 -0500
Received: by iyi12 with SMTP id 12so3428946iyi.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 11:38:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292928100.3563.3.camel@jlt3.sipsolutions.net>
References: <AANLkTi=n4pUEy_3PYX=7wbY+zR4D8=EGDNN-NtqhFs2q@mail.gmail.com> <1292928100.3563.3.camel@jlt3.sipsolutions.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Tue, 21 Dec 2010 11:38:23 -0800
Message-ID: <AANLkTimGci-yzhbQwJSjFPGMq0vdQV=4iARb8DUZZZf_@mail.gmail.com>
Subject: Re: vendor IEs?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 21, 2010 at 2:41 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2010-12-19 at 16:53 -0800, Daniel Halperin wrote:
>> Is there a compiled list of vendor-specific IEs out there?  Googling
>> didn't offer much help.
>
> I'm not aware of any list, nor can there really be one since everybody
> who has an OUI is free to define their own IEs.
>
> That said, some of them are of course mostly standardised, like the WFA
> ones for WPA, WSC/WPS and P2P for instance. I don't think there's a even
> a comprehensive list of WFA ones though other than in what you get by
> combining all those standards.

On that note, if you wanted to define a custom IE what would you do?
How did the WFA get an OUI?  Is there a Linux OUI?

Dan
