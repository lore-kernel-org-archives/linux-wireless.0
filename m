Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:46723
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2KMGyO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 01:54:14 -0500
From: Sujith Manoharan <sujith@msujith.org>
Message-ID: <20641.61052.448610.964793@gargle.gargle.HOWL> (sfid-20121113_075416_861443_8E54BCDD)
Date: Tue, 13 Nov 2012 12:23:48 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Harshal Chhaya <harshal@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Looking for WiFi + BT combo cards
In-Reply-To: <CAJ8GFOgZ00SSLjwpFb_gQnPQVh7QpJeWb_m55KOp3+pi9VrRPQ@mail.gmail.com>
References: <CAJ8GFOgZ00SSLjwpFb_gQnPQVh7QpJeWb_m55KOp3+pi9VrRPQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Harshal Chhaya wrote:
> I am looking for WiFi + BT combo products/chipsets with a USB
> interface that are supported by compat-wireless.
> 
> I want to add wireless capabilities (both WiFi and Bluetooth) to an
> existing device that's running Linux. This device has a couple of USB
> ports.
> 
> I have found a few WiFi-only products but haven't found combo products.
> 
> If you know of any such network adapters, please let me know.

ath9k_htc supports WB193 which is a WLAN+BT combo device (USB). I am not sure
if these cards can be bought online. Coexistence has been enabled for this
card, but I don't think that performance would be anything to brag about.

Sujith
