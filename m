Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35539 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753782Ab1EXK0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 06:26:05 -0400
Date: Tue, 24 May 2011 11:27:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
Message-ID: <20110524112732.67d92b2f@lxorguk.ukuu.org.uk> (sfid-20110524_122624_639824_C574A701)
In-Reply-To: <4DDB81FD.2020903@broadcom.com>
References: <1306010973-5625-1-git-send-email-arend@broadcom.com>
	<20110522122325.108b1c86@lxorguk.ukuu.org.uk>
	<4DD905CC.8040407@broadcom.com>
	<20110522151959.7fd6e87e@lxorguk.ukuu.org.uk>
	<4DDB622B.1050005@broadcom.com>
	<20110524104404.336c765f@lxorguk.ukuu.org.uk>
	<4DDB81FD.2020903@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Not sure whether you mean the source code or the object code. I build 
> kernel with debug symbols so the sizes are bit higher.

nm will tell you the actual sizes. I think the n_gsm code is about 500
bytes or so and chunks of it inline.
