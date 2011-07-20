Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:44572 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab1GTPbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 11:31:38 -0400
Date: Wed, 20 Jul 2011 15:35:42 +0000
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: [PATCH 1/3] b43: replace DMA translation workarounds with just
 a one, commented
Message-ID: <20110720153542.69edd601@Nokia-N900> (sfid-20110720_173141_081215_F7C40E13)
In-Reply-To: <CACna6rxNyZquGMVz5RUWs58ty+KTeFkv5wcccBQyw2n2A7XLMA@mail.gmail.com>
References: <1311113542-2540-1-git-send-email-zajec5@gmail.com>
	<1311113542-2540-2-git-send-email-zajec5@gmail.com>
	<20110720011509.504022f8@maggie>
	<CACna6rwMe9-dHANpDLko5yy5wu521YTGXmqBr1JYh18tYt+Z4A@mail.gmail.com>
	<20110720105540.1c9d072c@maggie>
	<CACna6rxNyZquGMVz5RUWs58ty+KTeFkv5wcccBQyw2n2A7XLMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 20 Jul 2011 13:10:55 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> Sorry, for not explaining this well eno
> ugh. I'm afraid of situation where b44 driver supports 64-bit DMA
> device *without* handling this as such a device. 

A b44 or b43legacy device with 64bit DMA engine does not exist.
