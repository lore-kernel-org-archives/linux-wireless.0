Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:37351 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755528Ab0C3MiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 08:38:12 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH] rt2500usb: fix powersaving random failures
Date: Tue, 30 Mar 2010 14:38:06 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>, users@rt2x00.serialmonkey.com,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <201003290956.54234.linux@rainbow-software.org> <4BB18816.4040603@gmail.com> <201003301433.55355.linux@rainbow-software.org>
In-Reply-To: <201003301433.55355.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003301438.07917.linux@rainbow-software.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> rt2500pci does not seem to need this change. At least my card never stucks
> in state 3. But it does in state 3 - this message appears probably on each

It never stucks in state 1 but it does in state 3.

-- 
Ondrej Zary
