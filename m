Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:49077 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZAXL2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 06:28:14 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2855006fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 03:28:12 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] wireless-regdb: add example spec file
Date: Sat, 24 Jan 2009 12:27:48 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1232752577-24011-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1232752577-24011-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901241227.48939.helmut.schaa@gmail.com> (sfid-20090124_122822_787218_8E5CC1FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 24. Januar 2009 schrieb Luis R. Rodriguez:
> This is a simple example spec file which can be used
> by RPM distributions. Note that the man page isn't yet
> installed as it has not yet been commited.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---

[...]

> +%install
> +install -m 755 -d %buildroot/%crda_lib
> +install -m 644 regulatory.bin %buildroot/%{crda_lib}/regulatory.bin

Why not make use of "make DESTDIR=%buildroot install" here?

Helmut
