Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49938 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965946Ab2DLUGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 16:06:11 -0400
Received: by dake40 with SMTP id e40so2924442dak.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 13:06:11 -0700 (PDT)
Date: Thu, 12 Apr 2012 13:06:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120412200606.GA23764@kroah.com> (sfid-20120412_220633_218369_B3EF61F5)
References: <20120411231102.GA6404@kroah.com>
 <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
 <20120412002927.GA23167@kroah.com>
 <4F8733C1.7020305@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F8733C1.7020305@ahsoftware.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 12, 2012 at 09:57:53PM +0200, Alexander Holler wrote:
> Hello,
> 
> Am 12.04.2012 02:29, schrieb Greg KH:
> 
> >>is there any chance for this one to be included in this review cycle?
> >>
> >>http://www.spinics.net/lists/linux-wireless/msg87999.html
> >
> >Have you read Documentation/stable_kernel_rules.txt?  Based on that, I
> >don't think it can, yet, right?
> 
> Hmm, after reading that, I think the text could need an update about
> how to submit patches written by others (which can already be found
> in the upstream tree).
> 
> At least for me the text reads like only the authors can request
> inclusion of a patch into the stable tree.

Patches are always welcome, but I think you will find the file already
describes this (hint, the first '-' line for the Procedure section
handles it).

greg k-h
