Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:41077 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab1FHIUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 04:20:17 -0400
Date: Wed, 8 Jun 2011 10:20:01 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Arend van Spriel <arend@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	George Kashperko <george@znau.edu.ua>,
	Greg KH <greg@kroah.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"mb@bu3sch.de" <mb@bu3sch.de>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"bernhardloos@googlemail.com" <bernhardloos@googlemail.com>
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
Message-ID: <20110608102001.294a4ff2@maggie> (sfid-20110608_102030_186854_1FAFA718)
In-Reply-To: <BANLkTikUqj-R72XaOXnifhKv-n1ZSJMxDQ@mail.gmail.com>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	<201106061503.14852.arnd@arndb.de>
	<4DED48EA.7070001@hauke-m.de>
	<201106062353.40470.arnd@arndb.de>
	<4DEDF98C.6020905@broadcom.com>
	<4DEE9BCD.1030304@hauke-m.de>
	<BANLkTikUqj-R72XaOXnifhKv-n1ZSJMxDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 8 Jun 2011 02:06:11 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> Because full scanning needs one of the following:
> 1) Working alloc - not possible for SoCs

Isn't there a bootmem allocator available on MIPS?
