Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38381 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752713Ab1EVLWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 07:22:16 -0400
Date: Sun, 22 May 2011 12:23:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
Message-ID: <20110522122325.108b1c86@lxorguk.ukuu.org.uk> (sfid-20110522_132221_239794_5F42F561)
In-Reply-To: <1306010973-5625-1-git-send-email-arend@broadcom.com>
References: <1306010973-5625-1-git-send-email-arend@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 21 May 2011 22:49:33 +0200
"Arend van Spriel" <arend@broadcom.com> wrote:

> The brcm80211 driver in staging tree uses a crc8 function. Based on
> feedback from John Linville to move this to lib directory, the linux
> source has been searched. Although there is currently only one other
> kernel driver using this algorithm (ie. drivers/ssb) we are providing
> this as a library function for others to use.

Can we find a better name for it - there seem to be lots of CRC8 variants
that are different - eg bit direction and it's going to be confusing to
just call it 'crc8'
