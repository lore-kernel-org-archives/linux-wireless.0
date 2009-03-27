Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:44468 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbZC0WLx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 18:11:53 -0400
Date: Fri, 27 Mar 2009 22:11:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] rfkill/rfkill-input userspace API
Message-ID: <20090327221147.GA499@srcf.ucam.org> (sfid-20090327_231158_312166_63222128)
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 27, 2009 at 12:58:01PM -0300, Henrique de Moraes Holschuh wrote:

> Note: unless something is done to change the way X.org deals with
> input devices, rfkill-input is _useless_ in a large number of setups
> as far as input event handling goes, because it will never get any
> events after X.org evdev grabs the input device.

X.org evdev doesn't grab the input device. We fixed that precisely 
because it broke rfkill-input.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
