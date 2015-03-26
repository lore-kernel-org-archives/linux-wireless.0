Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbCZMSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 08:18:15 -0400
Date: Thu, 26 Mar 2015 13:18:10 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Jes.Sorensen@redhat.com, joe@perches.com,
	Larry.Finger@lwfinger.net, mail@beyermatthias.de
Subject: Re: [PATCH v3 01/15] staging: rtl8723au: Reformat whitespace to
 increase readability
Message-ID: <20150326121810.GA15960@kroah.com> (sfid-20150326_131829_937414_FD836528)
References: <1426739958-18949-1-git-send-email-m.v.b@runbox.com>
 <1426739958-18949-2-git-send-email-m.v.b@runbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426739958-18949-2-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 19, 2015 at 12:39:04AM -0400, M. Vefa Bicakci wrote:
> Adjust the whitespace in the signature, local variable declaration and
> initialization parts of a number of functions to increase readability
> in rtl8723au's rtw_security.c.
> 
> v2: Make sure that the arcfour_encrypt function's argument list is split
>     according to the kernel code style.

The "v2" stuff here should go below the --- line, otherwise it will show
up in the changelog :(

Please fix these all up and resend.

thanks,

greg k-h
