Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47333 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab1DAQBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 12:01:12 -0400
Received: by bwz15 with SMTP id 15so2631216bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 09:01:10 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 1 Apr 2011 12:01:09 -0400
Message-ID: <AANLkTimERiSQcFp2-F5OTM6KyQHEMsGvJaWsV4w4Rsed@mail.gmail.com>
Subject: products with Atheros AR9002U (UB94) ?
From: George Nychis <gnychis@cmu.edu>
To: linux-wireless@vger.kernel.org
Cc: Stephen.Chen@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am searching for a dual-band 802.11n USB wireless adapter with an
Atheros chipset for Linux use.  I have checked the Linux Wireless
products page, etc.  After doing some searching, I found that some
older 802.11n devices use the UB81/82/83 Atheros hardware with the
AR9001U, and some of the newer 802.11n Atheros hardware supports
AR9002U with the UB94.  Correct me if I'm wrong, but I think the main
difference is the AR9001U was 11n-draft, and the AR9002U is
11n-standard.  Other than that, both are dual-band and seem to support
most of the same?
http://www.atheros.com/media/product/product_78_file1.pdf

I did a bunch of searching for products with the AR9001U and AR9002U,
and found some with the AR9001U such as the Netgear WNDA3100 and
D-Link DWA-160.  However, I think that Rev.B of the DWA-160 actually
uses Ralink now.  I'd be hesitant to purchase one someone and end up
with Rev.B.

In terms of AR9002U, I am not finding much of anything.  Just
reference designs for the UB94, which I can't find any products that
use it.  Apparently, Luis and others asked this question a little
while back, and the response was sometime in Q3 2010 from Stephen
Chen:
http://comments.gmane.org/gmane.linux.kernel.wireless.general/51660

Now that we're on Q2 of 2011, are there any products on the market
with the AR9002U/UB94 that anyone has seen?  If an AR9002U/UB94 is
available, I'd go for it over the AR9001U.  It seems like ath9k has
the needed support for the AR9280.

Any feedback would be really helpful.  If I can't find anything with
the AR9002U, I'll pull the trigger on the WNDA3100 unless after some
more searching I find something better.

Thanks!
George
