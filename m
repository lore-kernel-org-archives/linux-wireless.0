Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:54231 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYGXIFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 04:05:25 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3286463wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 01:05:25 -0700 (PDT)
Message-ID: <3ace41890807240105k5626c793if9cb9a2e3f62835b@mail.gmail.com> (sfid-20080724_100530_533679_B3AF4044)
Date: Thu, 24 Jul 2008 09:05:25 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <488815DE.2000903@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <200807221613.34434.herton@mandriva.com.br>
	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
	 <200807221940.20009.herton@mandriva.com.br>
	 <4886AA3B.3000406@lwfinger.net> <4886C50E.6040304@lwfinger.net>
	 <1216824917.13587.9.camel@johannes.berg>
	 <48874F09.7060400@lwfinger.net>
	 <3ace41890807232028u576371a6ra944431327cac76c@mail.gmail.com>
	 <488815DE.2000903@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 6:40 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
<snipped>
> I will be submitting the proper patch tomorrow, particularly if it works for
> others.

I was being over-optimistic... it worked for me for a good while but
doesn't after a reboot/what-not.
So it probably needs to be done but there may be more missing.
Do we need to start the seq number from some where?

Hin-Tak
