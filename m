Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab3FEWpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 18:45:09 -0400
Date: Wed, 5 Jun 2013 15:45:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 02/13] staging: vt6656: clean up MACvSetBBType
Message-ID: <20130605224508.GB19437@kroah.com> (sfid-20130606_004513_915225_F3804882)
References: <1370463312.6213.17.camel@canaries64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370463312.6213.17.camel@canaries64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 05, 2013 at 09:15:12PM +0100, Malcolm Priestley wrote:
> Remove internal white space and camel case.
> 
> Camel case changes;
> pDevice -> priv
> pbyData -> data
> byType -> type
> 
> Functional change
> CONTROLnsRequestOut Length = ARRAY_SIZE(data)

Don't do more than one thing in a patch, don't mix coding style cleanups
with function changes please.

Please redo this whole series, odds are, you did the same thing with all
of these, right?

thanks,

greg k-h
