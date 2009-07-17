Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:64348 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZGQR57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 13:57:59 -0400
Received: by gxk9 with SMTP id 9so1825825gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 10:57:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247843954.25608.62.camel@mj>
References: <6306c640907142221o27c257aaw12f73da8118376f@mail.gmail.com>
	 <445f43ac0907151344q6d80ddeckc0c586b34d8ca7c5@mail.gmail.com>
	 <6306c640907152338k4a5fb474h481d5adba97507b1@mail.gmail.com>
	 <1247843954.25608.62.camel@mj>
Date: Fri, 17 Jul 2009 13:57:58 -0400
Message-ID: <b6c5339f0907171057t5f4c4540n10209a69fc27e926@mail.gmail.com>
Subject: Re: any controller working in AP mode ?
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Ram kumar <ramkumar.research@gmail.com>,
	Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2009 at 11:19 AM, Pavel Roskin<proski@gnu.org> wrote:
> I did a quick test with rt73usb.  hostapd starts sucessfully, and a
> client using ath5k can connect and transmit data.  A client using ath9k
> can connect (wpa_supplicant enters state CONNECTED), but no data goes
> through.  The same client connects fine to a normal AP (D-Link DIR-615).

Sounds like the AP doesn't buffer frames properly -- ath9k does power
saving but ath5k does not, yet.

-- 
Bob Copeland %% www.bobcopeland.com
