Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:39509
	"EHLO QMTA05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739AbYJSFx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 01:53:58 -0400
Message-ID: <48FACB0E.2040802@gentoo.org> (sfid-20081019_075412_515122_2B51D584)
Date: Sun, 19 Oct 2008 08:52:14 +0300
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: keithl@keithl.com, linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Trendnet TEW-424UB now Realtek 8187B
References: <20081004011510.GA10015@gate.kl-ic.com> <1223109126.24551.70.camel@johannes.berg>
In-Reply-To: <1223109126.24551.70.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> The Trendnet TEW-424B is now version 3.1R, and contains a RealTek
>> 8187B ( lsusb 0bda:8189 ) rather than the Zydas ZD1211RW .
>> So it should leave the list.  
> 
> Ugly. Should we have both on there maybe with a version number? Daniel?
> We can list the other one for rtl8187b too.

The 424B is not listed as a ZD1211 device. Several versions of the 424UB 
are listed with their specific version numbers (including the original 
one that has no version).

Daniel
