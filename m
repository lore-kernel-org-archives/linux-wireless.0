Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48267 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab0DATLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 15:11:43 -0400
Received: by wyb39 with SMTP id 39so672795wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 12:11:42 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201004012059.35748.mb@bu3sch.de>
References: <201004012059.35748.mb@bu3sch.de>
Date: Thu, 1 Apr 2010 21:11:41 +0200
Message-ID: <t2z2d0a357f1004011211mcab2fau167ac67550a0c958@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_Implement_IEEE_802=2E11=C3=BC?=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That's UN*TR*Ü* (TR == Turkey|Turkish, Ü == UE)! (see [1]).

- Sedat -

P.S.:
[1] http://www.glueckswand.de/bilder/humor.gif
Translation: Turkish Wheel  of  Fortune: I buy an "Ü" -> Bing, bing, bing, ...
[2] http://xkcd.com/ (Disable JavaScript first)

On Thu, Apr 1, 2010 at 8:59 PM, Michael Buesch <mb@bu3sch.de> wrote:
> Hi John,
>
> This patch implements IEEE 802.11ü. The official standard for German
> extensions to the IEEE 802.11 wireless standard.
>
> These extensions include:
> * LHSEC (Lederhosen-security): Just barely protects the important parts.
>  Leaves everything else fully exposed to the public, no matter how
>  harmful it is.
> * SAU (Stubborn authentication): The AP won't let you in. No matter what.
>  This is an advanced security feature.
> * BEER (drink-a-lot-of-beer-routing): Will route packets from STAs to randomly
>  chosen APs. It will do this excessively until all APs banned the STA.
> * SRAD (strict radio): This feature will open a popup window for every to be sent
>  packet on the desktop. This window will contain an application form that has
>  to be filled out and sent to the next administration office via snailmail. Upon
>  successful approval by the administration, the packet is officially certified
>  to go "on air" within a well defined timeframe.
>  This is an advanced security feature.
>
>
> Index: wireless-testing/net/mac80211/Kconfig
> ===================================================================
> --- wireless-testing.orig/net/mac80211/Kconfig  2010-04-01 20:43:20.000000000 +0200
> +++ wireless-testing/net/mac80211/Kconfig       2010-04-01 20:56:29.000000000 +0200
> @@ -226,3 +226,9 @@ config MAC80211_DRIVER_API_TRACER
>          trace.
>
>          If unsure, say N.
> +
> +config MAC80211_80211UE_SUPPORT
> +       bool "Support for 802.11ü"
> +       depends on GERMAN_PASSPORT
> +       help
> +         Say Y here, if you want to enab
> <CONNECTION INTERRUPTED>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
