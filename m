Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:7462 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYKSLRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 06:17:00 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1637903nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 03:16:59 -0800 (PST)
Message-ID: <f76a32050811190316o28a49cddte30214c217877078@mail.gmail.com> (sfid-20081119_121706_513504_3F0FBBDB)
Date: Wed, 19 Nov 2008 12:16:59 +0100
From: "Stefan Steuerwald" <salsasepp@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Fwd: p54: testing AP mode: cannot switch to master mode
In-Reply-To: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'd like to test the recent p54 AP mode patches against my XG-603
(ISL3886) MiniPCI card.
Tried that with the current wireless-testing.git, compiled ok, module
loads with 2.13.1.0.arm firmware.
I was under the impression that this should now work:
    iwconfig wlan1 mode Master
however it errors with:
    Error for wireless request "Set Mode" (8B06) : SET failed on
device wlan1 ; Invalid argument.

Being new to wireless, I'd please like a pointer on what to
investigate and which info to provide.

Thank you,
  Stefan.
