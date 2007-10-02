Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serenity.mcc.ac.uk ([130.88.200.93]:63578 "EHLO
	serenity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbXJBVDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 17:03:25 -0400
Message-ID: <4702B1F7.3040100@gentoo.org> (sfid-20071002_220328_824993_D72002E5)
Date: Tue, 02 Oct 2007 22:02:47 +0100
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: What happened with z1211?
References: <200710021147.55506.mb@bu3sch.de> <470272CE.60405@gentoo.org> <200710022239.09217.mb@bu3sch.de>
In-Reply-To: <200710022239.09217.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> When is that port going to happen then?
> I mean, the drop of z1211 is a huge regression for me, as I am
> using it in production environment.

We're aiming for 2.6.25. Right now zd1211rw-mac80211 does not really 
provide any big user advantages over zd1211rw so you should be able to 
use the existing driver until then.

Daniel

