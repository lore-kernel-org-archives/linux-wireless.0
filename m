Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:35860 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0BNBPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 20:15:14 -0500
Received: by ewy28 with SMTP id 28so3034960ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 13 Feb 2010 17:15:12 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/3] rt2x00: Introduce SoC interface type.
Date: Sun, 14 Feb 2010 02:15:08 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1266090949-5468-1-git-send-email-gwingerde@gmail.com> <1266090949-5468-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1266090949-5468-2-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201002140215.09109.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 February 2010, Gertjan van Wingerde wrote:
> Introduce the SoC interface type to detect SoC devices, instead of having
> them mimic being PCI devices.
> This allows for easier detection of SoC devices.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

