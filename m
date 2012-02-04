Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4132 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab2BDKpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Feb 2012 05:45:22 -0500
Message-ID: <4F2D0C07.1010704@broadcom.com> (sfid-20120204_114549_975667_CC539698)
Date: Sat, 4 Feb 2012 11:44:23 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	"Scott Sanbar" <scott.sanbar@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: BCM4331 fails to associate after suspend
References: <20120203222818.GA3749@ubuntu-mba>
In-Reply-To: <20120203222818.GA3749@ubuntu-mba>
Content-Type: text/plain;
 charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/2012 11:28 PM, Seth Forshee wrote:
> 
> I've been looking around a bit in the b43 and bcma drivers, but so far I
> haven't found the reason why this happens. Any help would be
> appreciated. Let me know if there's additional information I can
> provide.
> 

With which kernel version do you see these issues? BCMA suspend/resume
code has a fix in 3.3-rc1. So if you are seeing it on a 3.2 kernel,
please give it a try.

Gr. AvS

