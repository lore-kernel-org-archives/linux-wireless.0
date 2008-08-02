Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.siteground211.com ([209.62.36.12]:48586 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYHBI3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 04:29:00 -0400
Date: Sat, 2 Aug 2008 11:28:52 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Eugeniy Meshcheryakov <eugen@debian.org>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Message-ID: <20080802082851.GB8213@frodo> (sfid-20080802_102907_520330_994AD5EC)
Reply-To: me@felipebalbi.com
References: <4891D1B9.70703@imap.cc> <1217517915.10489.143.camel@johannes.berg> <4891E97C.1060302@imap.cc> <20080731165054.GA14485@tuxdriver.com> <4892391D.2010305@imap.cc> <20080731224357.GA9741@localhost.localdomain> <48939C97.5030608@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48939C97.5030608@imap.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 02, 2008 at 01:30:31AM +0200, Tilman Schmidt wrote:
> The acx module also loads all by itself, but complains about missing
> firmware and throws two backtraces:

<snip>

> Ok, next step I guess is trying to find that firmware image 'tiacx111usbc1B' on
> the temporarily appearing pseudo CD-ROM drive or on the real CD-ROM that came
> with the device. Trouble is I don't really know what I am looking for. The
> real CD-ROM contains several instances of a file named Fwusb1b.bin, could that
> be it? And if so, where should I copy it so that the acx driver will find it?

Try with that one, copy to /lib/firmware, if it doesn't work try with
the one from [1].

[1] http://www.cmartin.tk/acx/fw.tar.bz2

-- 
balbi
