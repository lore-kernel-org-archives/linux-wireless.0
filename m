Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:60817 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3BRFFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 00:05:46 -0500
Received: by mail-we0-f181.google.com with SMTP id t44so4326311wey.12
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2013 21:05:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E09AA5D37894474C897FDF8284D04380@KGDOMAIN.local>
References: <loom.20130214T000819-590@post.gmane.org> <CAGRGNgU4akuP=iKqUqpNbztB7P6DECm=-ug6QKxtsJdvMd9iCg@mail.gmail.com>
 <4A04400646FF41AE84629E8D1443AA89@KGDOMAIN.local> <CAGRGNgWBYOJeLnA64yT4Pp0JOd50UqnndA98Jmq1kRd25Fn-ZA@mail.gmail.com>
 <A91BB000EAB44D40A1C1EF25B3CD8761@KGDOMAIN.local> <CAGRGNgUnSuALDpZME=YrSDwTJQew+kdUHRrZskJBob8HHGcqVQ@mail.gmail.com>
 <E09AA5D37894474C897FDF8284D04380@KGDOMAIN.local>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 18 Feb 2013 16:05:25 +1100
Message-ID: <CAGRGNgUN0W-YZS31XVOsvzUJpjjPf0HM3gbQBbOZyTbQoYacrA@mail.gmail.com> (sfid-20130218_060550_787668_14A05BFD)
Subject: Re: Writing application code using sd8686
To: "Kevin & Pauline Gordon" <kgordon@paradise.net.nz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,

On Sat, Feb 16, 2013 at 9:03 AM, Kevin & Pauline Gordon
<kgordon@paradise.net.nz> wrote:
> Many thanks for your comments Julian. Configuring files is fine if one is
> not out and about. Today with free Wifi or for demo purposes gaining access
> as a guest to local systems one needs an api (library) to:
> Configure,
> Open,
> Enable Dhcp,
> Scan,
> Join
> to automatically join local wifi access point on the fly.
> If anyone has some thoughts on this, I am keen to hear (especially re
> Libertas).

Again, Libertas is irrelevant with respect to those operations, all
the details of the driver are abstracted away from userspace programs.

You're looking for something like Connman or Network Manager or Wicd.
These manage the card and connect to the network, including scanning,
joining, encryption, key management, dhcp, etc. They all have some
form of interface which you can use to configure them, e.g. d-bus or
some library or whatever.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
