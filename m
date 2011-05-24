Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56790 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752963Ab1EXJmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 05:42:39 -0400
Date: Tue, 24 May 2011 10:44:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
Message-ID: <20110524104404.336c765f@lxorguk.ukuu.org.uk> (sfid-20110524_114255_215999_2806DC9A)
In-Reply-To: <4DDB622B.1050005@broadcom.com>
References: <1306010973-5625-1-git-send-email-arend@broadcom.com>
	<20110522122325.108b1c86@lxorguk.ukuu.org.uk>
	<4DD905CC.8040407@broadcom.com>
	<20110522151959.7fd6e87e@lxorguk.ukuu.org.uk>
	<4DDB622B.1050005@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 24 May 2011 09:45:47 +0200
"Arend van Spriel" <arend@broadcom.com> wrote:

> On 05/22/2011 04:19 PM, Alan Cox wrote:
> > Is it just used for wireless in this form ?
> >
> > See the n_gsm and bluetooth code for what I think is the same crc
> > algorithm but in reverse bit order .
> 
> Hi Alan,
> 
> Look into the code in n_gsm and bluetooth code. The algorithm is the 
> same, but except for the bit order it also is using a different 
> polynomial. My current implementation has a fixed table. I could do the 
> table generation runtime with the polynomial and the bit order as 
> parameters. That would make it more general purpose.

Probably not worth it - its so tiny a piece of code anyway (< 500 bytes
or so) that it's going to be bigger not smaller if you do that !
