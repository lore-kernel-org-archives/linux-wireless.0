Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:39847 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933868AbYBON14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 08:27:56 -0500
Received: by nf-out-0910.google.com with SMTP id g13so349801nfb.21
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 05:27:51 -0800 (PST)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] Both rt2500usb and rt73 claim USB device 148f:2573
Date: Fri, 15 Feb 2008 14:20:27 +0100
Cc: Pavel Roskin <proski@gnu.org>,
	Mark Wallis <mwallis@serialmonkey.com>,
	linux-wireless@vger.kernel.org
References: <1203056096.30732.63.camel@dv> <DF448D07-5C48-43C0-B6DD-12AF17BE0943@serialmonkey.com> <20080215020738.7i4ba6miv4kk8cow@webmail.spamcop.net>
In-Reply-To: <20080215020738.7i4ba6miv4kk8cow@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802151420.28082.IvDoorn@gmail.com> (sfid-20080215_132817_272281_6B4EEAFA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 February 2008, Pavel Roskin wrote:
> Quoting Mark Wallis <mwallis@serialmonkey.com>:
> 
> > Hi Pavel,
> >
> > On 15/02/2008, at 5:14 PM, Pavel Roskin wrote:
> >
> >> My Level One WNC-0301USB v3 has USB ID 148f:2573, which is listed as
> >> compatible both in rt2500usb.c and rt73usb.c.  It only works with rt73
> >> but not with rt2500usb.
> >>
> >> Is this duplication intentional?
> >
> > I'm afraid so. That particular manufacturer I believe changed the
> > chipset they were using without updating their USD device ID's. We have
> > seen this a few times now and the only solution we have been able to
> > provide is to give the users instructions for blacklisting the
> > incorrect driver.
> >
> > I believe this has been discussed on this list previously.
> 
> Thanks and sorry for the noise.

P.S. your lucky it is only listed in 2 drivers. Some USB ID's
(mostly coming from Linksys) are known to have 4 different drivers
variating from Broadcom, Prism and Ralink. ;)

Ivo
