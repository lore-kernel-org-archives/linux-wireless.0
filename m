Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35278 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab0IDXhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Sep 2010 19:37:54 -0400
Received: by fxm13 with SMTP id 13so1950088fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Sep 2010 16:37:53 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Michael =?utf-8?q?B=C3=BCsch?= <mb@bu3sch.de>
Subject: Re: [PATCH] p54spi: Add error message for eeprom failure
Date: Sun, 5 Sep 2010 01:37:46 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1283640938.3538.7.camel@maggie>
In-Reply-To: <1283640938.3538.7.camel@maggie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201009050137.47106.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 05 September 2010 00:55:38 Michael Büsch wrote:
> This adds an error message for the eeprom request failure
> case. This way it's easier for the user to figure out
> what went wrong.
> 
> Signed-off-by: Michael Büsch <mb@bu3sch.de>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
