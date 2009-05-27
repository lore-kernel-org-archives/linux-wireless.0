Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:57462 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZE0IVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 04:21:32 -0400
Received: by bwz22 with SMTP id 22so4395408bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2009 01:21:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A1CD905.4090406@gmx.net>
References: <4A199FED.7000609@gmx.net>
	 <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>
	 <4A1B00E7.5070801@gmx.net>
	 <3ace41890905251414v75544ed4o7bafdb3cdc170d1d@mail.gmail.com>
	 <4A1B2186.3070107@gmx.net>
	 <3ace41890905252258p54d858b0qfc172284cb65423f@mail.gmail.com>
	 <4A1C1766.3030004@gmx.net> <4A1C74C1.7060600@gmx.net>
	 <3ace41890905261651l1cd3742bu5ac1af6f631798f3@mail.gmail.com>
	 <4A1CD905.4090406@gmx.net>
Date: Wed, 27 May 2009 09:21:33 +0100
Message-ID: <3ace41890905270121r4d724c73h2187b7a89931f46e@mail.gmail.com>
Subject: Re: RTL 8185
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Barkle <barkle@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2009 at 7:09 AM, Barkle <barkle@gmx.net> wrote:

> After "ifconfig wlan0 up" the system freeze
> It's just every time the interface has to work, it's gonna freeze. It
> doesn't matter if I use wpa_supplicant or ifupdown (which invokes at last
> wpa_supplicant, so far as I know, on the debian system)

Hmm, try to disable any devices on the pci bus which you don't use
with setpci <id> command=0 before anything else.
