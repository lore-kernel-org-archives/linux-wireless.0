Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60193 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755767Ab1EXM4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 08:56:12 -0400
Date: Tue, 24 May 2011 13:57:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
Message-ID: <20110524135705.00f7fb12@lxorguk.ukuu.org.uk> (sfid-20110524_145631_477834_53BB57A5)
In-Reply-To: <4DDB8AB5.7080808@broadcom.com>
References: <1306010973-5625-1-git-send-email-arend@broadcom.com>
	<20110522122325.108b1c86@lxorguk.ukuu.org.uk>
	<4DD905CC.8040407@broadcom.com>
	<20110522151959.7fd6e87e@lxorguk.ukuu.org.uk>
	<4DDB622B.1050005@broadcom.com>
	<20110524104404.336c765f@lxorguk.ukuu.org.uk>
	<4DDB81FD.2020903@broadcom.com>
	<20110524112732.67d92b2f@lxorguk.ukuu.org.uk>
	<4DDB8AB5.7080808@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 24 May 2011 12:38:45 +0200
"Arend van Spriel" <arend@broadcom.com> wrote:

> On 05/24/2011 12:27 PM, Alan Cox wrote:
> >> Not sure whether you mean the source code or the object code. I build
> >> kernel with debug symbols so the sizes are bit higher.
> > nm will tell you the actual sizes. I think the n_gsm code is about 500
> > bytes or so and chunks of it inline.
> 
> Not counting the crc table I assume.

I forget but I think including - its a tiny tiny bit of code once inlined.
