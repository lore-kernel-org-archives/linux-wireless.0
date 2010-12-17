Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56806.mail.re3.yahoo.com ([66.196.97.80]:46700 "HELO
	web56806.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752301Ab0LQL4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 06:56:10 -0500
Message-ID: <740412.10599.qm@web56806.mail.re3.yahoo.com>
Date: Fri, 17 Dec 2010 03:56:05 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH 04/17] rt2x00: fix hang when unplugging USB device in use
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: js@sig21.net, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
In-Reply-To: <AANLkTi=img36VOkKapcgZz54ZmtXRneai-W0bU_W5z=E@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> Odd I have been testing this while stresstesting the card,
> and either
> unplugging, rmmod or ifdown, and I couldn't
> reproduce any crashes. Has the stacktrace changed after
> these patches?

Hi.

I can confirm when the rt2800usb is loaded and an rt3070 chip is connected to a network, running 'rmmod rt2800usb rt2x00lib rt2x00usb rt2800lib' causes immediate system hang (and hard-reset).

I was not able to retrieve any relevant error logs.

Walter


      
