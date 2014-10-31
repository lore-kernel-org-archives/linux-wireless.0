Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295AbaJaJ7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 05:59:24 -0400
Date: Fri, 31 Oct 2014 10:55:26 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	stable@vger.kernel.org, Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH -stable] wireless: rt2x00: add new rt2800usb devices
Message-ID: <20141031095525.GA2214@redhat.com> (sfid-20141031_105927_964969_6D6DCBEA)
References: <1414667923-2331-1-git-send-email-xose.vazquez@gmail.com>
 <54535ABA.1030109@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54535ABA.1030109@suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2014 at 10:47:38AM +0100, Jiri Slaby wrote:
> On 10/30/2014, 12:18 PM, Xose Vazquez Perez wrote:
> > 0x0b05 0x17e8 RT5372 USB 2.0  bgn 2x2 ASUS USB-N14
> > 0x0411 0x0253 RT5572 USB 2.0 abgn 2x2 BUFFALO WLP-U2-300D
> > 0x0df6 0x0078 RT???? Sitecom N300
> 
> (the same as previous)

This is:

committ 6a06e554daef86c4e8d290284927b081fedb249e
Author: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date:   Fri Jul 11 21:46:57 2014 +0200

    wireless: rt2x00: add new rt2800usb devices

