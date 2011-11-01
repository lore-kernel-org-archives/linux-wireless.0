Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63071 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1KACss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 22:48:48 -0400
Received: by ggnb1 with SMTP id b1so6583035ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 19:48:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN8Fffq1M88zsMnmmcnCoRDm6WOUJ2=g5j4giRnXFHzcxSeQiQ@mail.gmail.com>
References: <CAN8Fffq1M88zsMnmmcnCoRDm6WOUJ2=g5j4giRnXFHzcxSeQiQ@mail.gmail.com>
Date: Tue, 1 Nov 2011 03:48:47 +0100
Message-ID: <CAGXE3d96AyYLKwZxR1N85d0KKQ6eEfTvGj814s5fduWLBCSNRA@mail.gmail.com> (sfid-20111101_034855_764058_609936FA)
Subject: Re: rt2800usb + rt3070 + AP(n mode)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Andrew V. Stepanov" <stanv@altlinux.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrew,

On Mon, Oct 31, 2011 at 12:04 PM, Andrew V. Stepanov <stanv@altlinux.org> wrote:
> Hello.
>
> I have USB Wireless Adapter (ID 148f:3070 Ralink Technology, Corp.
> RT2870/RT3070 Wireless Adapter).
> I successfuly  set this device to AccessPoint (master) mode with
> vanila kernel driver rt2800usb + hostapd. But only to G mode.
> I sees speed no more 2Mbps.
>
> Did any have success setup this device with ieee80211n=1?

Basically rt2800 should be able to work in 11n mode but AP mode in rt2800usb
lacks some important features like proper multi- and broadcast buffering for
powersaving stations.

Helmut
