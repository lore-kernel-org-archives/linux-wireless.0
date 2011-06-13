Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:40889 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1FMQ12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 12:27:28 -0400
Date: Mon, 13 Jun 2011 18:27:21 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Question about hosts drivers split between ssb and b43
Message-ID: <20110613182721.6cadccaf@maggie> (sfid-20110613_182731_217849_5F50B7E9)
In-Reply-To: <BANLkTin2cmA1RH5uDSmGOm4nAvicqiiQ6A@mail.gmail.com>
References: <BANLkTin2cmA1RH5uDSmGOm4nAvicqiiQ6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 13 Jun 2011 17:57:03 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> What is the reason of splitting few hosts drivers (sdio and pcmcia)
> into two pieces: one in the ssb and second in b43?

This stuff should actually be a standalone module.
However, because they are so tiny, we put it somewhere else into
and existing module.
Where to put it was decided on dependency.
