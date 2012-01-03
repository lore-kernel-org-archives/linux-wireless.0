Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48700 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab2ACAei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 19:34:38 -0500
Date: Tue, 3 Jan 2012 00:35:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>,
	Matthew Garrett <mjg@redhat.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120103003508.726f5482@pyramind.ukuu.org.uk> (sfid-20120103_013455_068841_E8AFDEC2)
In-Reply-To: <4F022214.8070906@fastmail.fm>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<4F02165C.1060400@fastmail.fm>
	<CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
	<4F0219AB.6010505@fastmail.fm>
	<CA+55aFx=AEG7X2Y-LoHchgPdwNpeSkBG1J7eXprmO=czEJOD2A@mail.gmail.com>
	<4F021CF4.9050205@fastmail.fm>
	<CA+55aFx2NMDSY8rmsToU-zxe+bR-gzsxc8HajNWNWfykVJqd9w@mail.gmail.com>
	<4F022214.8070906@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> To make the firmware caching easier I would propose one extra function
> in addition to the aforemensioned get_firmware / put_firmware - a
> find_firmware function to search the cache and return the appropriate
> firmware blob. 

If the caller has a recount they have a pointer. If the caller can't work
out how to assign a 32bit value to a field in a struct please get them to
work on something less important than kernel code.

Alan
