Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:35737 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2EFQDU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 12:03:20 -0400
Message-ID: <1336320142.5970.76.camel@aeonflux> (sfid-20120506_180335_409416_0D10F223)
Subject: Re: [PATCH] Bluetooth: Fix coding style
From: Marcel Holtmann <marcel@holtmann.org>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linville@tuxdriver.com, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Date: Sun, 06 May 2012 09:02:22 -0700
In-Reply-To: <1336157988-4602-1-git-send-email-gustavo@padovan.org>
References: <1336157988-4602-1-git-send-email-gustavo@padovan.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gustavo,

> Fix offending styles all over the tree. This is in conformance David
> Miller's style rules.
> 
> Signed-off-by: Gustavo Padovan <gustavo@padovan.org>
> ---
>  include/net/bluetooth/hci_core.h |    2 +-
>  net/bluetooth/hci_event.c        |    2 +-
>  net/bluetooth/l2cap_core.c       |   12 ++++++------
>  net/bluetooth/l2cap_sock.c       |    2 +-
>  4 files changed, 9 insertions(+), 9 deletions(-)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


