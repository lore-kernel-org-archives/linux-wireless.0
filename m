Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3559 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab2AYIR7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 03:17:59 -0500
Message-ID: <4F1FBAA9.4040405@broadcom.com> (sfid-20120125_091826_380000_78219AC9)
Date: Wed, 25 Jan 2012 09:17:45 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Francis Moreau" <francis.moro@gmail.com>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: kernel 3.2.1: BUG: scheduling while atomic:
 swapper/0/0/0x10000100
References: <CAC9WiBgpBCWZVjAQkJWSpXhC_dK1KKPfAHZvxVgaLV8BUsc41Q@mail.gmail.com>
In-Reply-To: <CAC9WiBgpBCWZVjAQkJWSpXhC_dK1KKPfAHZvxVgaLV8BUsc41Q@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2012 04:59 PM, Francis Moreau wrote:
> Hi,
> 
> Just in case someone is interested, I've been hit by this:
> 
> [  236.734640] BUG: scheduling while atomic: swapper/0/0/0x10000100

Hi Francis

I hit that problem yesterday as well on 3.3.0-rc1. I suspected it came
from my development changes on brcmfmac, but you are not using that.
Still I am looking into it trying some kernel hacking options in Kconfig.

Gr. AvS

