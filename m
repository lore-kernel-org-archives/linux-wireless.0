Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2276 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab2ARRGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 12:06:34 -0500
Message-ID: <4F16FC09.2040700@broadcom.com> (sfid-20120118_180637_907425_37546C61)
Date: Wed, 18 Jan 2012 18:06:17 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: Dan <dannyai.mobile@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Brcmsmac drivers
References: <F18570BE-C886-4182-9D73-943283F3EB8D@gmail.com>
 <4F1675DB.6070307@broadcom.com>
 <37E66FC3-F62A-49E3-9DBC-049C2BE19D87@gmail.com>
In-Reply-To: <37E66FC3-F62A-49E3-9DBC-049C2BE19D87@gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2012 12:40 PM, Dan wrote:
> Do you mean that wireless-testing will have monitor mode that will allow monitoring data packets from APs. Which I have mentioned isn't working within the latest stable compat-wireless. 
> 
> Thanks
> Dan
> 

Your v3.2(?) kernel should have bcma enabled. I also made some changes
to bcma on which brcmsmac depends in v3.3. I don't think compat-wireless
does everything for you. So building a new kernel straight from
wireless-testing is probably your best bet.

Gr. AvS

