Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44972 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab1JRGYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 02:24:15 -0400
Received: by iaek3 with SMTP id k3so341133iae.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 23:24:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318887043.75699.YahooMailClassic@web39406.mail.mud.yahoo.com>
References: <1318887043.75699.YahooMailClassic@web39406.mail.mud.yahoo.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 18 Oct 2011 17:23:54 +1100
Message-ID: <CAGRGNgVE61GF3pVv1ynPQUdG6KdfAM7e8QjD1+eXuNf_T40=9Q@mail.gmail.com> (sfid-20111018_082418_482088_0E3A82DC)
Subject: Re: Looking for driver; Intel Pro 2915ABG wireless card
To: J C <excelsior415@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi J C,

On Tue, Oct 18, 2011 at 08:30, J C <excelsior415@yahoo.com> wrote:
> Hello, I'm looking to install the most appropriate wireless driver in my Ubuntu 10.04. It's likely the file is "w29n51.inf" but I cannot find it online. The Windows Drivers software is installed on this machine, but if there is a Linux file or direct placement of this driver I'd be also interested.

You're asking on the wrong mailing list. This mailing list is about
the development of wireless drivers for Linux, not the usage of
Windows drivers through some compatibility layer.

That said, this card is supported by the ipw2200 driver, which has
been part of the Linux kernel for years, providing you have
appropriate firmware.

The driver is usually loaded automatically when the card is detected,
and your Linux distribution should have a package containing this
firmware, or it can be downloaded at

http://ipw2200.sourceforge.net/

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
