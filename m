Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:44079 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0ESS07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 14:26:59 -0400
Received: by ewy8 with SMTP id 8so2790025ewy.28
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 11:26:56 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 5/7] rt2x00: Move PCI/USB specific register initializations to rt2800{pci,usb}.
Date: Wed, 19 May 2010 20:26:52 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com> <1274282769-19244-6-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1274282769-19244-6-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201005192026.53773.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 19 May 2010 17:26:07 Gertjan van Wingerde wrote:
> This prevents us having common code depend on PCI or USB specific code.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---

To which tree are you creating your diffs?
This one doesn't apply to latest wireless-testing.git or rt2x00,git

Ivo
