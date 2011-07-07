Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:14355 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab1GGWZ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 18:25:28 -0400
Message-ID: <4E163255.6060502@gnu.org> (sfid-20110708_002534_950332_113B64A6)
Date: Thu, 07 Jul 2011 18:25:25 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Henry Ptasinski <henryp@broadcom.com>
CC: Greg KH <gregkh@suse.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: [RFC] Move brcm80211 to mainline
References: <20110707002034.GA17885@broadcom.com> <CACna6rx5EyZ-=2XgWawdN_Qu2t1K1sdHZydZFW6=TiX2QUwMfw@mail.gmail.com> <4E1504A3.1070801@gnu.org> <20110707014512.GA21087@suse.de> <20110707144628.GF23944@broadcom.com> <20110707145822.GA29241@suse.de> <20110707215537.GS23944@broadcom.com>
In-Reply-To: <20110707215537.GS23944@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/07/2011 05:55 PM, Henry Ptasinski wrote:
> Building some cross-compiler toolchains now.  SPARC hardware to do anything
> native with seems to be getting very scarce, and trying to fit a PCIe minicard
> into one might be challenging ...

Those two things combined together should solve your challenge:

http://www.google.com/#q=PCI1PEX
http://www.google.com/#q=MP2W

-- 
Regards,
Pavel Roskin
