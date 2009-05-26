Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:47273 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbZEZF6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 01:58:08 -0400
Received: by bwz22 with SMTP id 22so3532311bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 25 May 2009 22:58:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A1B2186.3070107@gmx.net>
References: <4A199FED.7000609@gmx.net>
	 <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>
	 <4A1B00E7.5070801@gmx.net>
	 <3ace41890905251414v75544ed4o7bafdb3cdc170d1d@mail.gmail.com>
	 <4A1B2186.3070107@gmx.net>
Date: Tue, 26 May 2009 06:58:08 +0100
Message-ID: <3ace41890905252258p54d858b0qfc172284cb65423f@mail.gmail.com>
Subject: Re: RTL 8185
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Barkle <barkle@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 25, 2009 at 11:53 PM, Barkle <barkle@gmx.net> wrote:

> I need encryption, but it doesn't matter if I use the right values. The
> result is the same.

Look, your wpa_supplicant config says you are not using encryption, so
there is no need to use it at all (or did you edit that out as
well)??? If you keep editing out info nobody can help you...

>> Please gIve compat-wireless a go.
>>
>
> Please be a little pacient with me. I work on it.
> Do you need any further information?

I am asking to a 2nd time - try compat-wireless. Despite what you
might believe, the latest rc kernel does not give you the latest
wireless driver code; the latest compat-wireless does. It takes only a
few minutes to install (it just replaces the 50 wireless related
kernel modules.

Since you have a 32-bit intel CPU, if you don't mind downgrade the
kernel back to about 2.6.26 or 2.6.24, you might consider switching to
the realtek vendor driver. It is a bit ugly but it works well enough
with older kernels on 32-bit intel platforms. The code is on realtek's
web site.
http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=1&PFid=1&Level=6&Conn=5&DownTypeID=3&GetDown=false&Downloads=true

You also have the choice of using ndiswrapper, on 32-bit intel platforms.
