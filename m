Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36061 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaKCLFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2014 06:05:40 -0500
Date: Mon, 3 Nov 2014 11:05:37 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	stable@vger.kernel.org, Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH -stable] wireless: rt2x00: add new rt2800usb devices
Message-ID: <20141103110536.GH6874@hercules> (sfid-20141103_120547_620846_5B00B391)
References: <1414667923-2331-1-git-send-email-xose.vazquez@gmail.com>
 <54535ABA.1030109@suse.cz>
 <20141031095525.GA2214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20141031095525.GA2214@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2014 at 10:55:26AM +0100, Stanislaw Gruszka wrote:
> On Fri, Oct 31, 2014 at 10:47:38AM +0100, Jiri Slaby wrote:
> > On 10/30/2014, 12:18 PM, Xose Vazquez Perez wrote:
> > > 0x0b05 0x17e8 RT5372 USB 2.0  bgn 2x2 ASUS USB-N14
> > > 0x0411 0x0253 RT5572 USB 2.0 abgn 2x2 BUFFALO WLP-U2-300D
> > > 0x0df6 0x0078 RT???? Sitecom N300
> > 
> > (the same as previous)
> 
> This is:
> 
> committ 6a06e554daef86c4e8d290284927b081fedb249e
> Author: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Date:   Fri Jul 11 21:46:57 2014 +0200
> 
>     wireless: rt2x00: add new rt2800usb devices
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks, queuing this patch for the 3.16 kernel.

Cheers,
--
Luís
