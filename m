Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33558 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423940AbcBQWvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 17:51:21 -0500
Received: by mail-io0-f179.google.com with SMTP id z135so54522404iof.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2016 14:51:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56C4E955.8080008@lwfinger.net>
References: <20160217060909.694a9aff@libertarian.asterius.net>
	<56C499E0.3070909@lwfinger.net>
	<20160217115746.6e2edbcf@libertarian.asterius.net>
	<56C4E955.8080008@lwfinger.net>
Date: Wed, 17 Feb 2016 23:51:20 +0100
Message-ID: <CACna6rzDsk0OSUepjpveryW=f=ynwzbFf7eVMk+_M7KAtz1bCA@mail.gmail.com> (sfid-20160217_235125_497836_B9C970DE)
Subject: Re: Wrong wireless nick card name loaded on reboot
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: German <gentgerman@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 February 2016 at 22:42, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> There is some kind of hardware problem causing two different IDs to be read.
> Assuming that everything else is working correctly, it is likely the wifi
> card at fault. If you can get to the card on your machine, I suggest
> reseating it in its socket just in case it is a contact problem. Otherwise,
> I have no suggestions.

You could also try moving this card to another device if you have
some. Or replacing your card with another one and see if it works
stable in this PC. Not sure if this will meet regulatory limitations,
but for testing PCI ID "stability" sounds like a safe idea.
