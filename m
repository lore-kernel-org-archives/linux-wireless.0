Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:49052 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZH3NaW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 09:30:22 -0400
Received: by ewy2 with SMTP id 2so3320494ewy.17
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2009 06:30:23 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: Fix TX status reporting
Date: Sun, 30 Aug 2009 15:30:19 +0200
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200908291910.14528.IvDoorn@gmail.com> <4A999024.6060800@free.fr>
In-Reply-To: <4A999024.6060800@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908301530.20077.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 August 2009, Benoit PAPILLAULT wrote:
> Ivo van Doorn a écrit :
> > Not all values of the TX status enumeration were covered during
> > updating of the TX statistics. This could lead to wrong bitrate
> > tuning but also wrong behavior in tools like hostapd.
> >
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> I have a pending patch about TX status that changed the meaning of
> TXDONE_FALLBACK just a bit... just to avoid this change in fact.
> I should be able to send those patches in few hours.
> 
> In my code, you success/failure of the packet is reported with
> TXDONE_SUCCESS / TXDONE_FAILURE. The TXDONE_FALLBACK is set
> independently to indicate that a fallback rate table has been used
> (and this could be the case for either success or failure).

Well that shouldn't block this patch at this time since it is a bugfix which
is quite important to get minstrel and hostapd working properly.

Once I have reviewed your patch it can be send upstream immediately or
in a single batch together with the rt2800pci driver. ;)

Ivo
