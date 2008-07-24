Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:14521 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYGXD2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 23:28:24 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3174280wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 20:28:23 -0700 (PDT)
Message-ID: <3ace41890807232028u576371a6ra944431327cac76c@mail.gmail.com> (sfid-20080724_052827_548054_C4255995)
Date: Thu, 24 Jul 2008 04:28:23 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <48874F09.7060400@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <200807221613.34434.herton@mandriva.com.br>
	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
	 <200807221940.20009.herton@mandriva.com.br>
	 <4886AA3B.3000406@lwfinger.net> <4886C50E.6040304@lwfinger.net>
	 <1216824917.13587.9.camel@johannes.berg>
	 <48874F09.7060400@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 4:32 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
<snipped>
>
> I tried something like that, but it didn't work. Maybe you can see what is
> wrong here:

Your patch actually works here! :-). Maybe you should retest?

It doesn't patch cleanly against wireless-testing - just indentation
oddness, I think.
Had to apply the patch by hand. but I am using it right now, so it
seems to work.

If somebody else retest okay, can we have this in wireless-testing
prompto, please?

Hin-Tak
