Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f217.google.com ([209.85.218.217]:33414 "EHLO
	mail-bw0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0EDPcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 11:32:04 -0400
Received: by bwz9 with SMTP id 9so2277008bwz.29
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 08:32:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1272986923.2486.45.camel@gnutoo-desktop>
References: <1272986923.2486.45.camel@gnutoo-desktop>
Date: Tue, 4 May 2010 17:32:00 +0200
Message-ID: <q2na32f33a41005040832n7d50a934q4ff0a6a4dde53f28@mail.gmail.com>
Subject: Re: [Fwd: USB AP card and/or rt2870 issue]
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: GNUtoo <GNUtoo@no-log.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 4, 2010 at 5:28 PM, GNUtoo <GNUtoo@no-log.org> wrote:
> hi, I sent the following mail(attached) to the hostapd mailing list,but
> Now I think It's a driver issue.
> Is it possible to make an access point with a rt2870 card.
> Does the driver support it?
> I don't have much hope for now as it is a staging driver...and it
> displayed a warning about that in dmesg...

You could try compat-wireless and the rt2800usb driver.
That one actually does have Master mode support, but doesn't work
on all cards yet. rt2800usb is also found in the main kernel tree, but
using compat-wireless will give you the most recent version with
_many_ fixes applied to it. :)

Ivo
