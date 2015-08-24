Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35066 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbbHXOmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 10:42:49 -0400
Received: by oiew67 with SMTP id w67so81621366oie.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2015 07:42:49 -0700 (PDT)
Subject: Re: Getting started on switching rtl8188eu staging driver to
 LIB80211/MAC80211
To: Sreenath Madasu <Sreenath.Madasu@gmail.com>,
	linux-wireless@vger.kernel.org
References: <loom.20150824T013723-25@post.gmane.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55DB2D62.6090002@lwfinger.net> (sfid-20150824_164303_403245_1B9A9826)
Date: Mon, 24 Aug 2015 09:42:42 -0500
MIME-Version: 1.0
In-Reply-To: <loom.20150824T013723-25@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2015 06:40 PM, Sreenath Madasu wrote:
> Hi all,
> I want to work on the TODO tasks
>
> - switch to use LIB80211
> - switch to use MAC80211
>
> for staging driver rtl8188eu.
>
> How can I start? Where is the documentation?

There is no specific documentation for this device, only what is available in 
the mac80211, cfg80211, and nl80211 code. You could also look at the drivers in 
drivers/net/wireless/ for ideas. The driver must be rewritten. You could 
consider Jes Sorensen's work on producing a mac80211 driver for the RTL8723AU 
that has been posted on this mailing list. He started with a Realtek USB driver 
that is similar to r8188eu.

Larry


