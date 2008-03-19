Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:7808 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761862AbYCSUpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 16:45:30 -0400
Received: by py-out-1112.google.com with SMTP id u52so770019pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2008 13:45:30 -0700 (PDT)
Message-ID: <646765f40803190449m16421197m7519aeefab577920@mail.gmail.com> (sfid-20080319_204619_644811_C9686E5D)
Date: Wed, 19 Mar 2008 22:49:48 +1100
From: "Julian Calaby" <julian.calaby@gmail.com>
To: "Markus Becker" <mab@comnets.uni-bremen.de>
Subject: Re: Marvell 88w8335 [Libertas]
Cc: linux-wireless@vger.kernel.org, "Dan Williams" <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org, david@woodhou.se,
	dwmw2@infradead.org, andreamrl@tiscali.it
In-Reply-To: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 19, 2008 at 9:00 PM, Markus Becker
<mab@comnets.uni-bremen.de> wrote:
> Dear all,
>
>  I am trying to use the WLAN part of an Option Fusion+ UMTS and WLAN card.
>  UMTS is working fine, WLAN works OK with ndiswrapper. Seen the emails on
>  infradead and linuxwireless from 2007 and beginning of March, I was trying
>  to get it natively supported.

You and me both.

>  I modified the mac80211 port of mrv8k from
>  http://david.woodhou.se/mrv.tar.gz so that it compiles against 2.6.24
>  Debian kernel.

Cool!

>  It is available here:
>  https://www.comnets.uni-bremen.de/~mab/mrv8k/mrv8kng-mab.tgz

Thanks!

>  The firmware I am using is extracted from Mrvw123.sys from the CD of the
>  UMTS/WLAN card using mrv8k_extract_fw.

I'm currently working on making this firmware extractor a little more
generic, and at the very least work successfully for all the drivers I
can gather for cards based upon these chips.

>  The module loads (does not bail out in the interrupt handler) and
>  creates the devices:

You're much further along than I am, I've not even started to attempt
to get any of the drivers I have working yet.

[snip]
>  If someone is interested in helping (I am not very familiar with linux
>  wireless development), please contact me.

I'm not familiar either, however I hope to use this as a learning
experience, and maybe then get some of the other non-working cards
I've got lying around going too. (acx111 and rt2500usb, possibly the
card in my wrt54g too)


As for my driver effort, I'm calling my driver mvw8k to differentiate
it from the other w8xxx drivers out there, and am planning to write it
completely from the ground up.

I intend to get some small part of it working this weekend - probably
the LED as a proof of concept - before starting on the real wireless
code. If you want to experience the joys of blinking LEDs, ping me and
I'll send you the code once it's working.

I don't have any development resources set up at the moment, e.g.
website, git repository, wiki, bug tracking, forums, etc. However I
may also set those up this weekend.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
