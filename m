Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:34861 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbZGAPFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 11:05:39 -0400
Subject: Re: [PATCH] rt2x00: use wiphy rfkill interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
In-Reply-To: <200907011517.35638.IvDoorn@gmail.com>
References: <200907011517.35638.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 08:05:48 -0700
Message-Id: <1246460748.12994.152.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,

> Remove the input_polldev from rt2x00 and replace it with
> the rfkill interface offered by the wiphy structure. This
> simplifies the entire rfkill handling in rt2x00 and allows
> us to remove the CONFIG_RT2X00_LIB_RFKILL option and always
> enables rfkill capabilities.

as I mentioned in Berlin last week, I think this is the right way of
doing this. So ACK.

Regards

Marcel


