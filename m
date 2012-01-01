Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:46302 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2AAJqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jan 2012 04:46:40 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Marek Vasut <marek.vasut@gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Sun, 1 Jan 2012 10:48:18 +0100
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Matthew Garrett <mjg@redhat.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	USB list <linux-usb@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
References: <20111230235421.GA6054@redhat.com> <CA+55aFyqm4FbW=--7U4ULk1EBb6RLP0sRgtokODBYnZNiJXWew@mail.gmail.com> <201112311939.19170.marek.vasut@gmail.com>
In-Reply-To: <201112311939.19170.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201201011048.18953.oliver@neukum.org> (sfid-20120101_104711_307508_D4DFC155)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 31. Dezember 2011, 19:39:18 schrieb Marek Vasut:

> maybe we should implement such thing into the firmware loader itself? Allow it 
> -- for example via some node in /dev -- to force loading firmware into some 
> buffer in kernel just before suspend so it'll certainly be readily available at 
> resume time?

This is difficult. We don't know at suspend time which firmware we will
need at resume time. We could keep a record of firmware we needed
to get to the state we are, but this is a very complex scheme.

	Regards
		Oliver
