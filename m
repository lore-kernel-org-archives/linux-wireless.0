Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50405 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbZLWIQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 03:16:17 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so6063598ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 00:16:16 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 4/5] rt2x00: convert RT2800PCI_PCI and RT2800PCI_SOC Kconfig symbols to booleans.
Date: Wed, 23 Dec 2009 09:16:14 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1261523005-5856-1-git-send-email-gwingerde@gmail.com> <1261523005-5856-4-git-send-email-gwingerde@gmail.com> <1261523005-5856-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1261523005-5856-5-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912230916.14521.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 December 2009, Gertjan van Wingerde wrote:
> There is no need for Kconfig symbols RT2800PCI_PCI and RT2800PCI_SOC to be
> tristates, as they are only used to check whether RT2800 PCI or SOC support
> is to be compiled in.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

