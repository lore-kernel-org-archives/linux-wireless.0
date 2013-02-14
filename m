Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:51320 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3BNEg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 23:36:26 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so1522252wgb.8
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2013 20:36:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20130214T000819-590@post.gmane.org>
References: <loom.20130214T000819-590@post.gmane.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 14 Feb 2013 15:36:04 +1100
Message-ID: <CAGRGNgU4akuP=iKqUqpNbztB7P6DECm=-ug6QKxtsJdvMd9iCg@mail.gmail.com> (sfid-20130214_053631_557767_A37115A2)
Subject: Re: Writing application code using sd8686
To: Kevin Gordon <kgordon@paradise.net.nz>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,

On Thu, Feb 14, 2013 at 10:13 AM, Kevin Gordon <kgordon@paradise.net.nz> wrote:
> Is it possible to write C/C++ code to use sd8686.bin driver? Is there a SDK or
> header/source files available? I would much appreciate your advice.

What exactly are you trying to do here?

sd8686.bin is the firmware image for Marvell 8686 wireless cards, not
a driver as such.

If you're after a driver to use those cards under Linux, you need to
ensure that your kernel the "libertas" driver available.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
