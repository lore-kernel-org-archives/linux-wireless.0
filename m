Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64102 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0IVJ6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 05:58:20 -0400
Received: by fxm3 with SMTP id 3so165974fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 02:58:19 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: pull request: wireless-next-2.6 2010-09-21
Date: Wed, 22 Sep 2010 11:58:13 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20100921201705.GC2448@tuxdriver.com> <20100921.183614.245388137.davem@davemloft.net>
In-Reply-To: <20100921.183614.245388137.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009221158.13806.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 September 2010 03:36:14 David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Tue, 21 Sep 2010 16:17:05 -0400
> 
> Pulled, but I suspect the 'packed' attribute usage is wrong in
> ath/carl9170 and can just be deleted.

which __packed do you think can be removed?

Note:
The overzealous use of __packed is a result of a report from Al Viro
for ar9170usb: "arm will pad even between u8's".
 
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=commit;h=1269fa737f21b3f643e4b12d3ac9938b142a7f00
