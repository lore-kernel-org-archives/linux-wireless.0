Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2753 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0LUSdW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 13:33:22 -0500
Message-ID: <4D10F2E3.3010905@broadcom.com>
Date: Tue, 21 Dec 2010 10:33:07 -0800
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Daniel Halperin" <dhalperi@cs.washington.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: vendor IEs?
References: <AANLkTi=n4pUEy_3PYX=7wbY+zR4D8=EGDNN-NtqhFs2q@mail.gmail.com>
 <1292928100.3563.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1292928100.3563.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2010 02:41 AM, Johannes Berg wrote:
> On Sun, 2010-12-19 at 16:53 -0800, Daniel Halperin wrote:
>> Is there a compiled list of vendor-specific IEs out there?  Googling
>> didn't offer much help.
>
> I'm not aware of any list, nor can there really be one since everybody
> who has an OUI is free to define their own IEs.
>
> That said, some of them are of course mostly standardised, like the WFA
> ones for WPA, WSC/WPS and P2P for instance. I don't think there's a even
> a comprehensive list of WFA ones though other than in what you get by
> combining all those standards.

The most complete info I've seen is in the wireshark dissector, but even 
that is not very complete.

- Henry


