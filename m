Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45902 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab1FQVKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 17:10:00 -0400
Received: by fxm17 with SMTP id 17so1988942fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 14:09:59 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Thomas Novin <thomas@xyz.pp.se>
Subject: Re: Status of carl9170
Date: Fri, 17 Jun 2011 23:10:42 +0200
Cc: linux-wireless@vger.kernel.org
References: <1308255196.4264.7.camel@thnov-desktop.xyz.lan> <1308321840.7789.12.camel@thnov-desktop.xyz.lan> <1308322679.7789.13.camel@thnov-desktop.xyz.lan>
In-Reply-To: <1308322679.7789.13.camel@thnov-desktop.xyz.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201106172310.42817.chunkeey@googlemail.com> (sfid-20110617_231009_572434_BA38AA54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 17 June 2011 16:57:59 Thomas Novin wrote:
> On fre, 2011-06-17 at 16:44 +0200, Thomas Novin wrote:
> > > Ok, can you please tell which option helped? If it was noht, then
> > > you should check if there is a newer firmware for your router.
> 
> I noticed that I only have 802.11b/g now, did noht disable 802.11n?
exactly, this switch disables 11n in case there's a problem.

http://wireless.kernel.org/en/users/Drivers/carl9170#A802.11n_Compatibility

I wonder if there's an OpenWRT port for the AP you got ;)

Regards,
	Chr
