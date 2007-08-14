Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:4711 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760291AbXHNGUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 02:20:33 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1358601rvb
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2007 23:20:32 -0700 (PDT)
Message-ID: <efe7343f0708132320t7fa2a302nff21a841438dfa1c@mail.gmail.com>
Date: Tue, 14 Aug 2007 07:20:32 +0100
From: "Luis Correia" <luis.f.correia@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: wireless drivers that doesn't require firmware
Cc: "maali Al Janoob" <mms82@hotmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708132121.49345.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <BAY111-F3063D70AED453915236D9FB6DC0@phx.gbl>
	 <200708132121.49345.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On 8/14/07, Michael Wu <flamingice@sourmilk.net> wrote:
> On Monday 13 August 2007 15:04, maali Al Janoob wrote:
> > Do you know any linux wireless drivers that implements all 802.11 related
> > functionalities in software and doesn't require a firmware? The only one
> > that I know is madwifi, do you know others?
> >
>
> All Realtek chips - rtl8180, rtl8185, rtl8187.
> All ADMtek ADM8211 chips (but they're not made anymore)
> Some Ralink chips, IIRC. Don't know which ones.

Ralink chips:

rt2400 (11b only  pci, minipci and cardbus)
rt2500 (11b/g pci, minipci and cardbus)
rt2570 USB (only old devices, there are some similar named ones)

>
> -Michael Wu
>
>

 Luis Correia
