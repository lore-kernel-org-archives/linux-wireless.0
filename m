Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp201.alice.it ([82.57.200.97]:58596 "EHLO smtp201.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab1EZPSt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 11:18:49 -0400
Subject: Re: %d in wlan log messages
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
In-Reply-To: <BANLkTina0R-SJamJ_GFbxJsYcvvdyxzZNg@mail.gmail.com>
References: <4DDE63B4.4030309@broadcom.com>
	 <BANLkTina0R-SJamJ_GFbxJsYcvvdyxzZNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 17:18:39 +0200
Message-ID: <1306423119.31794.6.camel@gnutoo-desktop> (sfid-20110526_171852_780657_BF4FBE53)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-26 at 08:09 -0700, Daniel Halperin wrote:
> are set by userspace, right?
> On my Ubuntu 10.04.2 LTS system, it's
> /etc/udev/rules.d/70-persistent.net.rules (or so, this is from
> memory). Not a kernel bug.
I've the same, with a recent compat wireless(iwconfig returns wlan%d) of
some days ago.

My setup(HTC dream under the SHR GNU/Linux distribution) uses devtmpfs
only tough(and some userspace middleware that also does firmware
loading).

Denis.

