Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail10.dslextreme.com ([66.51.199.98]:59991 "HELO
	mail10.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754093Ab0CEC1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 21:27:30 -0500
Message-ID: <4B906A81.6090703@gmail.com>
Date: Thu, 04 Mar 2010 18:20:49 -0800
From: Gus Wirth <gwirth79@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: RTL8187 coverage class
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to implement a first go at getting coverage class working for
a Realtek RTL8187L chip similar to the way it is in ath5k. I know I need
to change the ack timeout and the slot times but I can't quite decipher
the register use. I can see some hints in the function rtl8187_conf_erp
but that doesn't seem enough.

It seems that the values for SLOT, DIFS and EIFS aren't directly
converted to microseconds, so I'm not sure how those values were arrived at.

I want to start by just hard coding some different initial values to
allow for testing. My test device right now is an Alfa AWUS036H which is
a high power USB (500mW claimed)  RTL8187L and testing at a range of
about 2 kilometers, making the coverage class=5.

Gus
