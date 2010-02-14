Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:35860 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195Ab0BNBP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 20:15:28 -0500
Received: by mail-ew0-f228.google.com with SMTP id 28so3034960ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 13 Feb 2010 17:15:28 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 3/3] rt2x00: rework RT chipset and revision determination for PCI an SOC devices.
Date: Sun, 14 Feb 2010 02:15:25 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1266090949-5468-1-git-send-email-gwingerde@gmail.com> <1266090949-5468-3-git-send-email-gwingerde@gmail.com> <1266090949-5468-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1266090949-5468-4-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201002140215.26020.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 February 2010, Gertjan van Wingerde wrote:
> The recent rt2800 devices are no longer really identified by their PCI
> ID's, but rather by the contents of their CSR0 register. Also for the
> other chipsets is the contents of this CSR0 register important.
> Change the chipset determination logic to be more aligned with the rt2800
> model.
> Preparation for the support of rt3070 / rt3090 based devices.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
