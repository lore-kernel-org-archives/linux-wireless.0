Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:33821 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbZLHO5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 09:57:13 -0500
Received: by fg-out-1718.google.com with SMTP id 16so221092fgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 06:57:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091207215903.GC18939@tuxdriver.com>
References: <bf87febf0912030507u1c36f6a9h7cac0efabf3d016@mail.gmail.com>
	 <20091204192315.GA5786@tuxdriver.com>
	 <bf87febf0912070205k40a7286dpbb48cfcc494203d2@mail.gmail.com>
	 <20091207215903.GC18939@tuxdriver.com>
Date: Tue, 8 Dec 2009 09:57:16 -0500
Message-ID: <b6c5339f0912080657s7cfccd4dp6525702e609bdd5f@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: add support for Dell Vostro A860 LED
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Shahar Or <mightyiampresence@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 7, 2009 at 4:59 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Mon, Dec 07, 2009 at 12:05:54PM +0200, Shahar Or wrote:
>> Adds support for the WiFi activity LED on the Dell Vostro A860 laptop.
>>
>> Signed-off-by: Shahar Or <shahar@shahar-or.co.il>
>> ---
>> I hope this one is perfect.

Thanks for the patch.  As for getting a better solution to LEDs, I
trolled through the ACPI spec and code, and while various modules
do set up LED pins, there doesn't seem to be a way to generally
get that information from another module and it appears different
between each vendor.  I am by no stretch expert in ACPI stuff
though.

Luis, I've asked this before but maybe you know better now or know
whom to ask on your side.  Atheros must have a way on Windows to
figure out the LED pin/polarity -- do you have any idea?  Ath9k
uses the SREV but that seems to be insufficient for ath5k judging
by all the quirks.

-- 
Bob Copeland %% www.bobcopeland.com
