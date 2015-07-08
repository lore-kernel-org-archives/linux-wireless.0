Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36124 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000AbbGHLsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 07:48:18 -0400
Received: by widjy10 with SMTP id jy10so214714647wid.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jul 2015 04:48:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMArcTUjCviPJUBO6BQKt0MT29-KC7sM=eeF87OHZWQYO50xJw@mail.gmail.com>
References: <CAFSTUk6UasnV4P3B1TR7kSx1ToQTC+PC2hU6PynDBWJ3ALJzyg@mail.gmail.com>
	<55965CF8.20208@thinktube.com>
	<CAMArcTUvpBpTB=woMiY2mET+KOUKNLvY53Exb1F6vB+aztq6Lw@mail.gmail.com>
	<CAFSTUk6u6rNF1njVBMFT4VAKPZ0Y6BvHB3mJEu7H7oM3tma5tQ@mail.gmail.com>
	<559AD13B.7030105@thinktube.com>
	<CAFSTUk7T_kA0OxuUApQp0Nj0kqv0pS945Y+KssokYa2Ow2F+-g@mail.gmail.com>
	<CAMArcTVS5SaE605vf1yQgpUbXVaaoDS2Qcn1KJJnMVbrjbWkKg@mail.gmail.com>
	<CAMArcTUjCviPJUBO6BQKt0MT29-KC7sM=eeF87OHZWQYO50xJw@mail.gmail.com>
Date: Wed, 8 Jul 2015 12:48:17 +0100
Message-ID: <CAFSTUk632p88RKqA6xZ+Ro=qHGtP4V3CQin9B-K0qGkB7S8sUw@mail.gmail.com> (sfid-20150708_134823_087945_5CC89E5A)
Subject: Re: mesh support on rtl8192cu
From: Richard Palethorpe <richard@lm-technologies.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bruno Randolf <br1@thinktube.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 8, 2015 at 8:20 AM, Taehee Yoo <ap420073@gmail.com> wrote:
> Richard, I do apologize for my mistake.
> I found that the rtl8192cu can't send the beacon frame at mesh mode.
> Sender side wireshark shows sending beacon frame. but receiver side
> wireshark doesn't show the rtl8192cu's mesh beacon.
> I think connection issue's cause is rtl8192cu's wrong beacon code.

Thank you for looking into it Taehee. Using an adapter in monitor mode
I can see that the rtl8192cu is sending out beacon frames and ARP
packets over the air (if I use arping) in mesh mode.
