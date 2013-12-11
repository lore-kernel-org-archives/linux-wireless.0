Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:65241 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3LKUDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 15:03:18 -0500
Received: by mail-vb0-f48.google.com with SMTP id f13so1968018vbg.21
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 12:03:18 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Dec 2013 15:03:18 -0500
Message-ID: <CAGGtaNarW2fVT=KyCgYpCrZv914FQR26kQNza0VvKR2FBZrnMQ@mail.gmail.com> (sfid-20131211_210322_962944_2C00B463)
Subject: Doc for Qualcomm AR3001 HCI
From: Frank Zhao <frank.zhao.main@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I am doing some hacking on a PlayStation 4's DualShock 4 controller,
inside is a Qualcomm Atheros AR3002 connected to a microcontroller
using UART HCI. I have a logic analyzer connected to the UART signals
and I have captured a lot of data. But a lot of the HCI commands have
OGF of 0xFC which means that the commands are "vendor defined", and
thus they are not in the HCI functional specifications documentation.

I can't find any helpful technical documentation at all from
Qualcomm's website and they probably won't help some hobbyist anyways.
I've searched Google and found your website. You guys have written a
driver for this chip already, so you must have some documentation on
Qualcomm's own HCI commands. Can you please share this documentation
with me?

Thank you

Regards,
Frank Zhao
