Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52801 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbZHBBGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 21:06:01 -0400
Date: Sat, 1 Aug 2009 22:05:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-input@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL_ALL
Message-ID: <20090802010557.GA11073@khazad-dum.debian.net>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1249152859-14769-1-git-send-email-mjg@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 01 Aug 2009, Matthew Garrett wrote:
> This patch adds a new keycode, KEY_RFKILL_ALL. It indicates that the
> system should toggle the state of all rfkillable devices.

What should happen when you press it?  Toggle state, or the same as EV_SW
SW_RFKILL_ALL OFF (i.e. radios off, killing active) ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
