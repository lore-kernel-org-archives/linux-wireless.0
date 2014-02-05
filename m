Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:50379 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbaBEUkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 15:40:31 -0500
Date: Thu, 6 Feb 2014 07:40:14 +1100
From: James Cameron <quozl@laptop.org>
To: Giuseppe Siracusano <a_siracusano@tin.it>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Reduce tx power
Message-ID: <20140205204013.GA29649@us.netrek.org> (sfid-20140205_214047_869344_8BE019AB)
References: <1391599819.4118.3.camel@Core2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391599819.4118.3.camel@Core2>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't know about ath5k, but in usb8388 firmware (libertas driver)
there is a blinding table, into which MAC addresses were inserted, so
that the firmware would simulate test conditions.

Without a blinding table, sometimes nodes with minimal transmit power,
distance, and shielding, could still be reached.  RF sometimes works
better than you want.

-- 
James Cameron
http://quozl.linux.org.au/
