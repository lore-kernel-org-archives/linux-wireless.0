Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2722 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab2H2SPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 14:15:21 -0400
Message-ID: <503E5C24.7090700@broadcom.com> (sfid-20120829_201525_132515_FC5A2A07)
Date: Wed, 29 Aug 2012 20:15:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Julian Wollrath" <jwollrath@web.de>
cc: linux-wireless@vger.kernel.org
Subject: Re: brcmsmac: BCM43224 trace of a warning
References: <20120827152559.0b8a9502@aldoreel>
In-Reply-To: <20120827152559.0b8a9502@aldoreel>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/27/2012 03:25 PM, Julian Wollrath wrote:
> I do not really know what I did, when the warning was triggered but
> maybe the warning will be of interest nevertheless. I am using 3.6-rc3 +
> wireless-testing/master as of yesterday (August 26th 2012). If
> you need more information, please feel free to ask; if you have some
> hints, on how to find what caused the problem, please tell me.

This is a known issue for some time and I am currently looking into 
this. The warning had several causes and some have been fixed already. 
However, it may still occur. So it is debug in progress and I hope to 
send out a patch soon (fingers crossed).

> With best regards,
> Julian Wollrath

Gr. AvS

