Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:39591 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab0DAMvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 08:51:47 -0400
Received: by ey-out-2122.google.com with SMTP id d26so75111eyd.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 05:51:46 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Luis Correia <luis.f.correia@gmail.com>
Subject: Re: [PATCH] Remove MCU requests for SoC platforms
Date: Thu, 1 Apr 2010 14:51:43 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
References: <t2yefe7343f1004010548tdb2db0a3h9570da736a269352@mail.gmail.com>
In-Reply-To: <t2yefe7343f1004010548tdb2db0a3h9570da736a269352@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201004011451.44204.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> @@ -1100,8 +1106,10 @@
>  	/*
>  	 * This device requires firmware and MCU access.
>  	 */

You manually edited your patch didn't you? :P
This doesn't apply since you changed the comment line.

Ivo

