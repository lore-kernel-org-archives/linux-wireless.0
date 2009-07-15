Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:43824 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbZGOUok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 16:44:40 -0400
Received: by an-out-0708.google.com with SMTP id d40so7646590and.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 13:44:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6306c640907142221o27c257aaw12f73da8118376f@mail.gmail.com>
References: <6306c640907142221o27c257aaw12f73da8118376f@mail.gmail.com>
Date: Wed, 15 Jul 2009 13:44:39 -0700
Message-ID: <445f43ac0907151344q6d80ddeckc0c586b34d8ca7c5@mail.gmail.com>
Subject: Re: any controller working in AP mode ?
From: Javier Cardona <javier@cozybit.com>
To: Ram kumar <ramkumar.research@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ram,

On Tue, Jul 14, 2009 at 10:21 PM, Ram kumar<ramkumar.research@gmail.com> wrote:
> 2.Marvell 8388 controller supports AP mode,but it seems marvell has
> not released the AP mode firmware.

The thin firmware that allows using the 8383 with mac80211 and
implement an AP with hostapd is available here:
http://dev.laptop.org/pub/firmware/libertas/thinfirm/

Javier
