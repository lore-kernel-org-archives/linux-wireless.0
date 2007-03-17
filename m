Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:55989 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752345AbXCQHCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 03:02:11 -0400
Message-ID: <20070317030210.ksweo8wcws0kkg8s@webmail.spamcop.net>
Date: Sat, 17 Mar 2007 03:02:10 -0400
From: Pavel Roskin <proski@gnu.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Paul TBBle Hampson <Paul.Hampson@pobox.com>,
	linux-wireless@vger.kernel.org
Subject: Re: prism54pci fails to read eeprom on PowerPC, then bugs in pci  code
References: <20070317034607.GA1522@keitarou>
	<200703170037.14875.flamingice@sourmilk.net> <1174107032.17023.14.camel@dv>
	<200703170105.19348.flamingice@sourmilk.net>
In-Reply-To: <200703170105.19348.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Michael Wu <flamingice@sourmilk.net>:

> On Saturday 17 March 2007 00:50, Pavel Roskin wrote:
> > Oh, and I'm amazed that somebody is using dadwifi-openhal verify the
> > hardware!  It's in a pretty poor shape right now.  It prints some
> > warnings because it starts with channel 0.  The interface can be brought
> > up if you set a valid channel, and I think it might scan.
> >
> Really? mac80211 should set the channel immediately after bringing the
> interface. If no channel is configured, it defaults to the first channel in
> the first mode that is registered.

Yes, really, but it's some internal sanity check, probably before the mac80211
layer is called.

--
Regards,
Pavel Roskin
