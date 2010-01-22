Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:14894 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab0AVXqu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 18:46:50 -0500
Message-ID: <4B5A38E7.5010206@irobot.com>
Date: Fri, 22 Jan 2010 15:46:47 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Subject: Re: FYI - new compat-wireless based on 2.6.33-rc4
References: <43e72e891001201213x6a2c203dl7121f2dde6d61fb9@mail.gmail.com> 	<4B5897C8.2080006@irobot.com> <43e72e891001211012y4f4c8721t7eb9e0eea0221820@mail.gmail.com> 	<4B58B432.5050200@irobot.com> <43e72e891001211217t17ffed80i2d5bc6f923b56210@mail.gmail.com> 	<4B58C622.2090004@irobot.com> <4B58C997.2060904@irobot.com> <43e72e891001211421l6c861f59mcaad3c5e39950b49@mail.gmail.com>
In-Reply-To: <43e72e891001211421l6c861f59mcaad3c5e39950b49@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct.  In this case, not your fault.  There is no openembedded recipe 
for compat-wireless, so I had to roll my own, and I flubbed it by 
leaving out the udev stuff.

Luis R. Rodriguez wrote:
> OK so not our fault? You just had to update your install target?

