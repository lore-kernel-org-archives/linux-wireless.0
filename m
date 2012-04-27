Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62463 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab2D0XCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 19:02:04 -0400
Received: by wibhq7 with SMTP id hq7so1087951wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Apr 2012 16:02:02 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: question about SPI hardware
Date: Sat, 28 Apr 2012 01:01:57 +0200
References: <4F9AC520.9040200@lwfinger.net>
In-Reply-To: <4F9AC520.9040200@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201204280101.58249.chunkeey@googlemail.com> (sfid-20120428_010209_011588_422CBE60)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 April 2012 18:11:12 Larry Finger wrote:
> The openSUSE kernel packagers are getting rid of all CONFIG options
> that are restricted to embedded hardware. Are there any examples of
> SPI devices that run off an SD or similar interface on general
> hardware? In particular, I am thinking about p54spi, but knowledge
> of other devices would be helpful.
There's the Sagrad's SG901-1049. But as far as I know this module
does not work "out-of-the-box" with the driver either. So yeah, I
don't think anyone would mind.

Regards,
	Christian
