Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40064 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694Ab0BSOdd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 09:33:33 -0500
Date: Fri, 19 Feb 2010 12:33:29 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linux-input@vger.kernel.org, marcel@holtmann.org
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Message-ID: <20100219143329.GD28522@khazad-dum.debian.net>
References: <1266356185-10324-1-git-send-email-mjg@redhat.com>
 <20100217052247.GD7160@core.coreip.homeip.net>
 <20100217180342.GA22522@srcf.ucam.org>
 <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com>
 <20100217191708.GA15554@core.coreip.homeip.net>
 <22ee4e771002171142q1496842ap4079026a5c0be8c6@mail.gmail.com>
 <20100217195435.GA15742@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100217195435.GA15742@core.coreip.homeip.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 17 Feb 2010, Dmitry Torokhov wrote:
> We did it with KEY_BATTERY but I do not think anyone actually uses it.

thinkpad-acpi does (in-tree).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
