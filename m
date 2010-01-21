Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f201.google.com ([209.85.222.201]:50404 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab0AUWVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 17:21:35 -0500
MIME-Version: 1.0
In-Reply-To: <4B58C997.2060904@irobot.com>
References: <43e72e891001201213x6a2c203dl7121f2dde6d61fb9@mail.gmail.com>
	<4B5897C8.2080006@irobot.com> <43e72e891001211012y4f4c8721t7eb9e0eea0221820@mail.gmail.com>
	<4B58B432.5050200@irobot.com> <43e72e891001211217t17ffed80i2d5bc6f923b56210@mail.gmail.com>
	<4B58C622.2090004@irobot.com> <4B58C997.2060904@irobot.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 21 Jan 2010 14:21:14 -0800
Message-ID: <43e72e891001211421l6c861f59mcaad3c5e39950b49@mail.gmail.com>
Subject: Re: FYI - new compat-wireless based on 2.6.33-rc4
To: Adam Wozniak <awozniak@irobot.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2010 at 1:39 PM, Adam Wozniak <awozniak@irobot.com> wrote:
> Ok, I see what's going on now.  The openembedded recipe I'm working with
> didn't copy the udev stuff.

OK so not our fault? You just had to update your install target?

  Luis
