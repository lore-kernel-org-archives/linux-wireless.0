Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50405 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbZLWIQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 03:16:07 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so6063598ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 00:16:07 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 3/5] rt2x00: Let rt2800lib check CONFIG_RT2X00_LIB_USB instead of CONFIG_RT2800USB
Date: Wed, 23 Dec 2009 09:16:05 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1261523005-5856-1-git-send-email-gwingerde@gmail.com> <1261523005-5856-3-git-send-email-gwingerde@gmail.com> <1261523005-5856-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1261523005-5856-4-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912230916.05557.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 December 2009, Gertjan van Wingerde wrote:
> rt2800lib currently checks whether RT2800USB is enabled in the configuration.
> Strictly speaking this is not necessary, it only needs to know whether the
> generic rt2x00usb library functions are available. Therefore check for
> RT2X00_LIB_USB instead.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
