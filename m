Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:58431 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0AKOD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 09:03:26 -0500
Received: by fxm7 with SMTP id 7so19811053fxm.29
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2010 06:03:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4B2B71.10909@lwfinger.net>
References: <4B4B2B71.10909@lwfinger.net>
Date: Mon, 11 Jan 2010 15:03:24 +0100
Message-ID: <f6ca9fed1001110603w2b9ddffcp840f243a9cce57a3@mail.gmail.com>
Subject: Re: System freezes with rt2860/2870
From: drago01 <drago01@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	mhilzinger@linuxnewmedia.de, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 11, 2010 at 2:45 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Ivo and Gertjan,
>
> The kernel in openSUSE 11.2 was recently upgraded from 2.6.31.5 to 2.6.31.8.
> Immediately, users of rt2860/2870 cards began reporting system freezes as soon
> as the device makes a wireless connection. For NM users, this is soon after
> login. The only recovery is power off. There is at least one bug report at
>
> https://bugzilla.novell.com/show_bug.cgi?id=568446
>
> Do you know any reason for a regression of this nature in the 2.6.31 stable
> code? I don't recall any similar complaints on the wireless list, but I don't
> always follow the rt2x00 stuff.

rt2860/2870 are the legacy drivers in stagging; the rt2x00 maintainers
aren't the right people to complain to ;)
